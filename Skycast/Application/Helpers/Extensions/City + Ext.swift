//
//  City + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import Foundation

extension City {
    var coordinate: Coordinate? {
        guard let lat, let lon else { return nil }
        return (lat, lon)
    }
}
