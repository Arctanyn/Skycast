//
//  DailyForecastCellViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 23.12.2022.
//

import Foundation
import Combine

final class DailyForecastCellViewModelImpl: DailyForecastCellViewModel {
    
    //MARK: Properties
    
    @Published private var forecastDay: ForecastDay?
    @Published private var temperatureUnits: TemperatureUnits
    
    var temperaturesPublisher: AnyPublisher<(low: Temperature, high: Temperature), Never> {
        lowTemperaturePublisher.combineLatest(highTemperaturePublisher)
            .map { (low: $0, high: $1) }
            .eraseToAnyPublisher()
    }
    
    var weatherCodePublisher: AnyPublisher<Int, Never> {
        $forecastDay
            .compactMap { $0?.day?.condition?.code }
            .eraseToAnyPublisher()
    }
    
    var weekdayPublisher: AnyPublisher<String, Never> {
        $forecastDay
            .compactMap { $0?.date?.convertToDate(format: DateFormat.dailyWeatherForecast.rawValue) }
            .map { return $0.toString(format: DateFormat.weekday.rawValue) }
            .eraseToAnyPublisher()
    }
    
    private var lowTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $forecastDay.combineLatest($temperatureUnits)
            .compactMap { weather, units in
                switch units {
                case .celsius:
                    return weather?.day?.mintempC?.convertToTemberature(in: units)
                case .fahrenheit:
                    return weather?.day?.mintempF?.convertToTemberature(in: units)
                }
            }
            .eraseToAnyPublisher()
    }
    
    private var highTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $forecastDay.combineLatest($temperatureUnits)
            .compactMap { weather, units in
                switch units {
                case .celsius:
                    return weather?.day?.maxtempC?.convertToTemberature(in: units)
                case .fahrenheit:
                    return weather?.day?.maxtempF?.convertToTemberature(in: units)
                }
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Initialization
  
    init(forecastDay: ForecastDay? = nil, temperatureUnits: TemperatureUnits) {
        self.forecastDay = forecastDay
        self.temperatureUnits = temperatureUnits
    }
    
}
