//
//  TemperatureConvertable.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

protocol TemperatureConvertable {
    var temperatureC: Double? { get }
    var temperatureF: Double? { get }
    func getTemperature(in units: TemperatureUnits) -> Temperature?
}

extension TemperatureConvertable {
    func getTemperature(in units: TemperatureUnits) -> Temperature? {
        switch units {
        case .celsius:
            return temperatureC?.convertToTemperature(in: units)
        case .fahrenheit:
            return temperatureF?.convertToTemperature(in: units)
        }
    }
}
