//
//  WeatherDetails.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 19.12.2022.
//

import UIKit

enum WeatherDetails: String, CaseIterable {
    case wind = "WIND"
    case humidity = "HUMIDITY"
    case pressure = "PRESSURE"
    case visibility = "VISIBILITY"
    
    var icon: UIImage {
        switch self {
        case .wind:
            return Resources.Images.Weather.wind
        case .humidity:
            return Resources.Images.Weather.drop
        case .pressure:
            return Resources.Images.Weather.arrowDownUp
        case .visibility:
            return Resources.Images.Weather.eye
        }
    }
}
