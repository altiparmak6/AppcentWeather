//
//  NewDetailViewModel.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 15.04.2022.
//

import Foundation



class NewDetailViewModel {

    var details = Observable<DetailModel>()
    
    var title: String {
        guard let title = details.value?.title else {
            return ""
        }
        return title
    }
    
    var temperature: String {
        guard let temparature = details.value?.consolidated_weather[0].theTemp else {
            return " "
        }
        return String(format:"%.1f°", temparature)
    }
    
    
    var weatherState: String {
        guard let weatherState = details.value?.consolidated_weather[0].weatherStateName else {
            return " "
        }
        return weatherState
    }
    
    var humidity: String {
        guard let humidity = details.value?.consolidated_weather[0].humidity else {
            return " "
        }
        return "Humidity: %\(humidity)"
    }
    
    var dateString: String {
        guard let applicableDate = details.value?.consolidated_weather[0].applicableDate else {
            return " "
        }
        return applicableDate
    }
    
    var weatherImageLink: String {
        guard let weatherStateAbbr = details.value?.consolidated_weather[0].weatherStateAbbr else {
            return " "
        }
        return "https://www.metaweather.com/static/img/weather/png/\(weatherStateAbbr).png"
    }
    
    
    //Need extra two days to get next week's data
    private var sixhtDay: String {
        return formatDate(dateString: dateString, addDay: 6)
    }
    
    private var seventhDay: String {
        return formatDate(dateString: dateString, addDay: 7)
    }
    

    

    
    let networkManager: NetworkManagerProtocol
    

    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    
    
    func getDetails(woeid: Int) {
        networkManager.getWeatherDetail(with: woeid) { [weak self] detailModel in
            
            guard let self = self else {
                return
            }
            self.details.value = detailModel //Gets todays and next 5 days data
            
            
            //Make extra two call and append to complete today's and next 7 days data
            self.networkManager.getFutureDetail(woeid: woeid, formattedDateString: self.sixhtDay) { consolidatedData in
                self.details.value?.consolidated_weather.append(consolidatedData)
                
                self.networkManager.getFutureDetail(woeid: woeid, formattedDateString: self.seventhDay) { [weak self] consolidatedData in
                    self?.details.value?.consolidated_weather.append(consolidatedData)
                    
                }
            }
            
            
        }
    }
    
  
    
    
    
    
    ///input yyyy-MM-dd   output yyyy/MM/dd
    ///Get future date string by adding number of days to current day
    private func formatDate(dateString: String, addDay: Int) -> String {

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy/MM/dd"

        let formattedDate = dateFormatter.date(from: dateString)!

        
        let futureDate = Calendar.current.date(byAdding: .day, value: addDay, to: formattedDate)
        
        return dateFormatter.string(from: futureDate!)
    }
    

}
