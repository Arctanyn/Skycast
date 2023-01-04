//
//  LocationCollectionViewCellViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation
import Combine

protocol LocationCollectionViewCellViewModel {
    var locationWeather: Weather? { get }
    var weatherRecievedPublisher: AnyPublisher<Bool, Never> { get }
    var locationNamePublisher: AnyPublisher<String, Never> { get }
    var temperaturePublisher: AnyPublisher<Temperature, Never> { get }
    var conditionPublisher: AnyPublisher<String, Never> { get }
    var weatherIconPublisher: AnyPublisher<(code: Int, dayPeriod: DayPeriod), Never> { get }
    var lowTemperaturePublisher: AnyPublisher<Temperature, Never> { get }
    var highTemperaturePublisher: AnyPublisher<Temperature, Never> { get }
    func getWeather()
}
