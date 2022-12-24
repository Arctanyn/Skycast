//
//  CurrentWeatherViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation
import Combine

protocol CurrentWeatherViewModel {
    var iconUpdatePublisher: AnyPublisher<(code: Int, dayPeriod: DayPeriod), Never> { get }
    var temperaturePublisher: AnyPublisher<Temperature, Never> { get }
    var conditionPublisher: AnyPublisher<String, Never> { get }
    var locationPublisher: AnyPublisher<String, Never> { get }
}
