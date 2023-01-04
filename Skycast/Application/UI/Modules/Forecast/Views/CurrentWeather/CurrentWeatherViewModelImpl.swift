//
//  CurrentWeatherViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation
import Combine

final class CurrentWeatherViewModelImpl: CurrentWeatherViewModel {
    
    //MARK: Properties
    
    @Published private var weather: CurrentWeather?
    @Published private var location: Location?
    @Published private var temperatureUnits: TemperatureUnits
    
    var iconUpdatePublisher: AnyPublisher<(code: Int, dayPeriod: DayPeriod), Never> {
        codePublisher.combineLatest(dayPeriodPublisher)
            .map { (code: $0, dayPeriod: $1) }
            .eraseToAnyPublisher()
    }
    
    var temperaturePublisher: AnyPublisher<Temperature, Never> {
        $weather.combineLatest($temperatureUnits)
            .compactMap { weather, units in
                guard let weather else { return nil }
                return (weather, units)
            }
            .flatMap { weather, units in
                Just(weather).mapToTemperature(in: units)
            }
            .eraseToAnyPublisher()
    }
    
    var conditionPublisher: AnyPublisher<String, Never> {
        $weather
            .compactMap { $0?.condition?.text }
            .eraseToAnyPublisher()
    }
    
    var locationPublisher: AnyPublisher<String, Never> {
        $location
            .compactMap { location in
                guard let name = location?.name, let country = location?.country else { return nil }
                return "\(name), \(country)"
            }
            .eraseToAnyPublisher()
    }
    
    private var dayPeriodPublisher: AnyPublisher<DayPeriod, Never> {
        $weather
            .compactMap { $0?.isDay }
            .compactMapToDayPeriod()
            .eraseToAnyPublisher()
    }
    
    private var codePublisher: AnyPublisher<Int, Never> {
        $weather
            .compactMap { $0?.condition?.code }
            .eraseToAnyPublisher()
    }
    
    init(weather: CurrentWeather? = nil, location: Location? = nil, temperatureUnits: TemperatureUnits) {
        self.weather = weather
        self.location = location
        self.temperatureUnits = temperatureUnits
    }
    
}
