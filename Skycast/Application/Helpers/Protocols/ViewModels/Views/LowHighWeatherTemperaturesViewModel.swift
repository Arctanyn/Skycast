//
//  LowHighWeatherTemperaturesViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import Foundation
import Combine

protocol LowHighWeatherTemperaturesViewModel {
    var minTemperaturePublisher: AnyPublisher<Temperature, Never> { get }
    var maxTemperaturePublisher: AnyPublisher<Temperature, Never> { get }
}
