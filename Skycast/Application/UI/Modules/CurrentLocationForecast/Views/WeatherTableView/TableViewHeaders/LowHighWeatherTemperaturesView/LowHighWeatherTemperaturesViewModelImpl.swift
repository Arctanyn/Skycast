//
//  LowHighWeatherTemperaturesViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import Foundation
import Combine

final class LowHighWeatherTemperaturesViewModelImpl: LowHighWeatherTemperaturesViewModel {
    
    //MARK: Properties
    
    @Published private var day: Day?
    @Published private var temperatureUnits: TemperatureUnits
    
    var minTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $day.combineLatest($temperatureUnits)
            .compactMap { day, units in
                guard let day else { return nil }
                return (day, units)
            }
            .flatMap { day, units in
                Just(day).mapToTemperature(type: .low, in: units)
            }
            .eraseToAnyPublisher()
    }
    
    var maxTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $day.combineLatest($temperatureUnits)
            .compactMap { day, units in
                guard let day else { return nil }
                return (day, units)
            }
            .flatMap { day, units in
                Just(day).mapToTemperature(type: .high, in: units)
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Initialization
    
    init(day: Day? = nil, temperatureUnits: TemperatureUnits) {
        self.day = day
        self.temperatureUnits = temperatureUnits
    }
}
