//
//  WeatherModel.swift
//  Weather
//
//  Created by Zaur on 08.12.2022.
//

import Foundation

struct WeatherModel: Decodable{
    let location: Location?
    let current: Current?
}

struct Location: Decodable {
    let name: String?
    let region: String?
    let country: String?
}

struct Current: Decodable {
    let last_updated: String?
    let temp_c: Int?
    let condition: Condition?
}

struct Condition: Decodable {
    let text: String?
    let icon: String?
}
