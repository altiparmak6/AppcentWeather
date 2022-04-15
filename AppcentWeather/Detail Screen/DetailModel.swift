//
//  ResponseModel.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 14.04.2022.
//

import Foundation


struct DetailModel: Decodable {
    var consolidated_weather: [ConsolidatedWeather]
    let parent: Parent
    let title: String
}


struct ConsolidatedWeather: Codable {
    let id: Int
    let weatherStateName, weatherStateAbbr, windDirectionCompass: String
    let applicableDate: String
    let minTemp, maxTemp, theTemp, windSpeed: Double
    let windDirection, airPressure: Double?
    let humidity: Int
    let visibility: Double?
    let predictability: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case theTemp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability
    }
}


struct Parent: Codable {
    let title, locationType: String
    let woeid: Int
    let lattLong: String

    enum CodingKeys: String, CodingKey {
        case title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
    }
}
