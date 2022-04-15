//
//  SearchViewModel.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 15.04.2022.
//

import Foundation


class SearchViewModel {
    
    var locationModel = Observable<SearchedLocationModel>()
    
    let searchResults = Observable<[SearchedLocationModel]>()
    
    
    var searchString: String = "" {
        didSet {
            queryLocations()
        }
    }

    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    

    
    
    func queryLocations() {
        networkManager.queryLocations(query: searchString) { locations in
            self.searchResults.value = locations
        }
    }
    
    
    
}
