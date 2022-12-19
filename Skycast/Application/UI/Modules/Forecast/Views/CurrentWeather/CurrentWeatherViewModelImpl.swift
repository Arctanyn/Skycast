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
    
    @Published private var weather: CurrentWeather?
    @Published private var location: Location?
    
    //MARK: - Methods
    
    func updateWeather(_ weather: CurrentWeather?, for location: Location?) {
        self.weather = weather
        self.location = location
    }
    
}
