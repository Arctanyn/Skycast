//
//  HourlyForecastCellViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 24.12.2022.
//

import Foundation
import Combine

protocol HourlyForecastCellViewModel {
    var temperaturePublisher: AnyPublisher<Temperature, Never> { get }
    var hourPublisher: AnyPublisher<String, Never> { get }
    var conditionPublisher: AnyPublisher<String, Never> { get }
    var weatherIconPublisher: AnyPublisher<(code: Int, dayPeriod: DayPeriod), Never> { get }
}
