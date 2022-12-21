//
//  Int + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 21.12.2022.
//

import Foundation

extension Int {
    func toTemperature(in units: TemperatureUnits) -> String {
        return String(self) + units.rawValue
    }
}
