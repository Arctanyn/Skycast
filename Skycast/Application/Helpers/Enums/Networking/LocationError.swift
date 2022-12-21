//
//  LocationError.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 21.12.2022.
//

import Foundation

enum LocationError: LocalizedError {
    case failedToGetLocation
    
    var errorDescription: String? {
        switch self {
        case .failedToGetLocation:
            return "Couldn't get current location"
        }
    }
}
