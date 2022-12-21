//
//  CurrentWeatherViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation
import Combine

protocol CurrentWeatherViewModel {
    var iconUpdatePublisher: AnyPublisher<(dayTime: DayTime, code: Int), Never> { get }
    var temperaturePublisher: AnyPublisher<Int, Never> { get }
    var conditionPublisher: AnyPublisher<String, Never> { get }
    var locationPublisher: AnyPublisher<String, Never> { get }
    func updateWeather(_ weather: CurrentWeather?, for location: Location?)
}
