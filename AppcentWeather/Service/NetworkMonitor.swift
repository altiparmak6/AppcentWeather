//
//  NetworkMonitor.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 14.04.2022.
//

import Foundation
import Network

class NetworkMonitor {
    private let monitor = NWPathMonitor()
    
    let isConnected = Observable<Bool>()
    
    
    func startMonitoring() {

        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isConnected.value = true
            } else {
                self.isConnected.value = false
            }
        }
        
        monitor.start(queue: .global())
    }
}
