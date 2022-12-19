//
//  WeatherTemperatureViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import Foundation
import Combine

protocol WeatherTemperatureViewModel {
    var minTemperaturePublisher: AnyPublisher<Int, Never> { get }
    var maxTemperaturePublisher: AnyPublisher<Int, Never> { get }
}
