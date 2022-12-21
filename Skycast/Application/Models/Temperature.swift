//
//  Temperature.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 21.12.2022.
//

import Foundation

struct Temperature {
    var degrees: Int
    var units: TemperatureUnits
    
    var stringFormat: String {
        degrees.toTemperature(in: units)
    }
}
