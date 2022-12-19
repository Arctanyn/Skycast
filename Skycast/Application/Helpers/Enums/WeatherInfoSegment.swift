//
//  WeatherSegment.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation

enum WeatherInfoSegment: Int, CaseIterable {
    case details
    case hourly
    case forecast
    
    var title: String {
        switch self {
        case .details:
            return "Details"
        case .hourly:
            return "Hourly"
        case .forecast:
            return "3-Day"
        }
    }
}
