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
        $forecastDay
            .compactMap { $0?.day?.mintempC }
            .map { $0.toRoundedInt }
            .mapToTemperature(in: .celsius)
            .eraseToAnyPublisher()
    }
    
    private var highTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $forecastDay
            .compactMap { $0?.day?.maxtempC }
            .map { $0.toRoundedInt }
            .mapToTemperature(in: .celsius)
            .eraseToAnyPublisher()
    }
    
    //MARK: - Initialization
    
    init(forecastDay: ForecastDay? = nil) {
        self.forecastDay = forecastDay
    }
    
}
