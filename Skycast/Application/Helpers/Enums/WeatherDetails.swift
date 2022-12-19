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
//    case dewPoint = "DEW POINT"
    case pressure = "PRESSURE"
    case visibility = "VISIBILITY"
    
    var icon: UIImage {
        switch self {
        case .wind:
            return Resources.Images.wind
        case .humidity:
            return Resources.Images.drop
//        case .dewPoint:
//            return Resources.Images.dropDegreesign
        case .pressure:
            return Resources.Images.arrowDownUp
        case .visibility:
            return Resources.Images.eye
        }
    }
}
