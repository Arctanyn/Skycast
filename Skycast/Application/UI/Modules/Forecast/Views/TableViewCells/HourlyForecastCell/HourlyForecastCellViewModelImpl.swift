//
//  HourlyForecastCellViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 24.12.2022.
//

import Foundation
import Combine

final class HourlyForecastCellViewModelImpl: HourlyForecastCellViewModel {
    
    //MARK: Properties
    
    @Published private var hour: Hour?
    
    var temperaturePublisher: AnyPublisher<Temperature, Never> {
        $hour.combineLatest($temperatureUnits)
            .compactMap { hour, units in
                switch units {
                case .celsius:
                    return hour?.tempC?.convertToTemberature(in: units)
                case .fahrenheit:
                    return hour?.tempF?.convertToTemberature(in: units)
                }
            }
            .eraseToAnyPublisher()
    }
    
    var hourPublisher: AnyPublisher<String, Never> {
        $hour
            .compactMap {
                $0?.time?.convertToDate(format: DateFormat.hourlyWeatherForecast.rawValue)
            }
            .map { $0.toString(format: DateFormat.hour.rawValue) }
            .eraseToAnyPublisher()
    }
    
    var conditionPublisher: AnyPublisher<String, Never> {
        $hour
            .compactMap { $0?.condition?.text }
            .eraseToAnyPublisher()
    }
    
    var weatherIconPublisher: AnyPublisher<(code: Int, dayPeriod: DayPeriod), Never> {
        codePublisher.combineLatest(dayPeriodPublisher)
            .map { (code: $0.0, dayPeriod: $0.1) }
            .eraseToAnyPublisher()
            
    }
    
    private var dayPeriodPublisher: AnyPublisher<DayPeriod, Never> {
        $hour
            .compactMap { $0?.isDay }
            .compactMapToDayPeriod()
            .eraseToAnyPublisher()
    }
    
    private var codePublisher: AnyPublisher<Int, Never> {
        $hour
            .compactMap { $0?.condition?.code }
            .eraseToAnyPublisher()
    }
    
    @Published private var temperatureUnits: TemperatureUnits
    
    //MARK: - Initialization
    
    init(hour: Hour?, temperatureUnits: TemperatureUnits) {
        self.hour = hour
        self.temperatureUnits = temperatureUnits
    }

}
