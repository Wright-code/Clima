//
//  WeatherData.swift
//  Clima
//
//  Created by Harry Wright on 06/10/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
}

struct Main: Decodable {
    let temp : Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct Wind: Decodable {
    let speed: Double
    let deg: Int
}
