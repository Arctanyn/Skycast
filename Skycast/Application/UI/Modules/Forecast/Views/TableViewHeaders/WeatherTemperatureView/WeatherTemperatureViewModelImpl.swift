//
//  WeatherTemperatureViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import Foundation
import Combine

final class WeatherTemperatureViewModelImpl: WeatherTemperatureViewModel {
    
    //MARK: Properties
    
    @Published private var day: Day?
    @Published private var temperatureUnits: TemperatureUnits
    
    var minTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $day.combineLatest($temperatureUnits)
            .compactMap { day, units in
                switch units {
                case .celsius:
                    return day?.mintempC?.convertToTemberature(in: units)
                case .fahrenheit:
                    return day?.mintempF?.convertToTemberature(in: units)
                }
            }
            .eraseToAnyPublisher()
    }
    
    var maxTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $day.combineLatest($temperatureUnits)
            .compactMap { day, units in
                switch units {
                case .celsius:
                    return day?.maxtempC?.convertToTemberature(in: units)
                case .fahrenheit:
                    return day?.maxtempF?.convertToTemberature(in: units)
                }
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Initialization
    
    init(day: Day? = nil, temperatureUnits: TemperatureUnits) {
        self.day = day
        self.temperatureUnits = temperatureUnits
    }
}
