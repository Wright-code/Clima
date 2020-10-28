//
//  WeatherModel.swift
//  Clima
//
//  Created by Harry Wright on 06/10/2020.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let windSpeed: Double
    let windDirection: Int
    
    var windDirectionAverage: String {
        switch windDirection {
        case 23...68:
            return "arrow.up.right"
        case 69...113:
            return "arrow.right"
        case 114...158:
            return "arrow.down.right"
        case 159...203:
            return "arrow.down"
        case 204...248:
            return "arrow.down.left"
        case 249...293:
            return "arrow.left"
        case 294...338:
            return "arrow.up.left"
        case 339...360:
            return "arrow.up"
        case 0...22:
            return "arrow.up"
        default: return "arrow.up"

        }
    }
    
    var windSpeedString: String {
        return String(format: "%.1f", windSpeed)
    }
    
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
