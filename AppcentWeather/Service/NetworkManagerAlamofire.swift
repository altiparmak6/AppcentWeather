//
//  ServiceAlamofire.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 14.04.2022.
//

import Foundation
import Alamofire

class NetworkManagerAlamofire: NetworkManagerProtocol {
    
    func searchByLocation(with coordinateString: String, completionHandler: @escaping ([NearLocationModel]) -> Void ) {
        let baseUrl = "https://www.metaweather.com/api/location/search/?lattlong="
        let urlString = "\(baseUrl)\(coordinateString)"
        
        AF.request(urlString, method: .get).validate().responseDecodable(of: [NearLocationModel].self) { (response) in
            guard let items = response.value else {
                return
            }
            
            completionHandler(items)
 
        }

    }
    
    
    
    
    
    
    func queryLocations(query: String, completionHandler: @escaping ([SearchedLocationModel]) -> Void) {
        let baseUrl = "https://www.metaweather.com/api/location/search/?query="
        let urlString = "\(baseUrl)\(query)"
        

        
        AF.request(urlString, method: .get).validate().responseDecodable(of: [SearchedLocationModel].self) { response in
            guard let items = response.value else {
                print("Network Error")
                return
            }
            
            if items.isEmpty {
                print("No location found")
                completionHandler([])
                return
            }
            
            completionHandler(items)

        }
        
        
    }

    
    
    

    
    func getWeatherDetail(with woeid: Int, completionHandler: @escaping (DetailModel) -> Void) {
        let baseUrl = "https://www.metaweather.com/api/location/"
        let urlString = "\(baseUrl)\(woeid)"
        
        AF.request(urlString, method: .get).validate().responseDecodable(of: DetailModel.self) { (response) in
            guard let item = response.value else {
                print("Network Error getWeatherData")
                return
            }
            
            completionHandler(item)
            
            
        }
    }
    
    
    func getFutureDetail(woeid: Int, formattedDateString: String, completionHandler: @escaping (ConsolidatedWeather) -> Void) {
        let baseUrl = "https://www.metaweather.com/api/location/"
        let urlString = "\(baseUrl)\(woeid)/\(formattedDateString)"
        
        AF.request(urlString, method: .get).validate().responseDecodable(of: [ConsolidatedWeather].self) { (response) in
            
            if let error = response.error {
                print(error)
            }
            guard let items = response.value else {
                return
            }
            
            //API can only return data for the next 5-10 days
            if items.isEmpty {
                return
            }
            
            
            completionHandler(items[0])
            
            
        }
    }
    
}
