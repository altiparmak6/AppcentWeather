//
//  HomeModel.swift
//  AppcentWeather
//
//  Created by Mustafa Altıparmak on 14.04.2022.
//

import Foundation


struct NearLocationModel: Decodable {
    
    let distance: Int
    let title: String
    let location_type: String
    let woeid: Int
    let latt_long: String
}
