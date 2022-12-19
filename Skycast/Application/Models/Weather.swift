//
//  Weather.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation

struct Weather: Decodable {
    let location: Location?
    let current: CurrentWeather?
    let forecast: Forecast?
}
