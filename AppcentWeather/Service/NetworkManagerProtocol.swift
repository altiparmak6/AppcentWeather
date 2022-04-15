//
//  NetworkManagerProtocol.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 15.04.2022.
//

import Foundation

protocol NetworkManagerProtocol {
    func searchByLocation(with coordinateString: String, completionHandler: @escaping ([NearLocationModel]) -> Void )
    func getWeatherDetail(with woeid: Int, completionHandler: @escaping (DetailModel) -> Void)
    func getFutureDetail(woeid: Int, formattedDateString: String, completionHandler: @escaping (ConsolidatedWeather) -> Void)
    func queryLocations(query: String, completionHandler: @escaping ([SearchedLocationModel]) -> Void)
}
