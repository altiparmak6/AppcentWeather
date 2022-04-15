//
//  HomeViewModel.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 14.04.2022.
//

import Foundation
import CoreLocation

class HomeViewModel: NSObject {
    
    let nearLocations = Observable<[NearLocationModel]>()
    let coordinateString = Observable<String>()

    var networkManager: NetworkManagerProtocol
    
    let locationManager = CLLocationManager()
    
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    
    func fetchNearLocations(with coordinateString: String) {
        
        networkManager.searchByLocation(with: coordinateString) { locations in
            self.nearLocations.value = locations
        }
    }
    
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
}





extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            let coordinate = "\(latitude),\(longitude)"
            coordinateString.value = coordinate
            print(coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}




