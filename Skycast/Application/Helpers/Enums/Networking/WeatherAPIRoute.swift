//
//  WeatherAPIRoute.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation

enum WeatherAPIRoute {
    case forecast
    
    var apiVersion: String { "v1" }
    
    var path: String {
        switch self {
        case .forecast:
            return "/\(apiVersion)/forecast.json"
        }
    }
}
