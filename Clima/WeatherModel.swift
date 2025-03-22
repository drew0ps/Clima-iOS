//
//  WeatherModel.swift
//  Clima
//
//  Created by Ádám Marton on 14.03.2025.
//  Copyright © 2025 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temp: Double
    
    var temperatureString: String {
        return String(format: "%.1f", temp)
    }
    
    var conditionName: String {
        switch conditionId {
        case 200..<233:
            return "cloud.bolt.rain"
        case 300..<322:
            return "cloud.drizzle"
        case 500..<533:
            return "cloud.rain"
        case 600..<623:
            return "cloud.snow"
        case 701..<782:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud"
        case 802:
            return "cloud"
        case 803..<805:
            return "cloud"
        default:
            return "11d"
        }
    }
}
