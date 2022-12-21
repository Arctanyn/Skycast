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
    
    var iconUpdatePublisher: AnyPublisher<(dayTime: DayTime, code: Int), Never> {
        dayTimePublisher.combineLatest(codePublisher)
            .map { (dayTime: $0, code: $1) }
            .eraseToAnyPublisher()
    }
    
    var temperaturePublisher: AnyPublisher<Int, Never> {
        $weather
            .compactMap { $0?.tempC?.rounded() }
            .map { Int($0) }
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
    
    private var dayTimePublisher: AnyPublisher<DayTime, Never> {
        $weather
            .compactMap { $0?.isDay }
            .compactMap { DayTime(rawValue: $0) }
            .eraseToAnyPublisher()
    }
    
    private var codePublisher: AnyPublisher<Int, Never> {
        $weather
            .compactMap { $0?.condition?.code }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Methods
    
    func updateWeather(_ weather: CurrentWeather?, for location: Location?) {
        self.weather = weather
        self.location = location
    }
    
}
