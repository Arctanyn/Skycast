//
//  WeatherDetailsCellViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 19.12.2022.
//

import Foundation
import Combine

final class WeatherDetailsCellViewModelImpl: WeatherDetailsCellViewModel {
    
    //MARK: Properties
    
    var type: WeatherDetails {
        return detailsType
    }
    
    var title: String {
        detailsType.rawValue
    }
    
    var value: Double {
        guard let weather else { return 0 }
        
        switch detailsType {
        case .wind:
            return weather.windKph ?? 0
        case .humidity:
            return Double(weather.humidity ?? 0)
        case .pressure:
            return weather.pressureIn ?? 0
        case .visibility:
            return weather.visKM ?? 0
        }
    }
    
    var valuePublisher: AnyPublisher<Double, Never> {
        $weather
            .compactMap { $0 }
            .map { [weak self] currentWeather in
                switch self?.detailsType {
                case .wind:
                    return currentWeather.windKph ?? 0
                case .humidity:
                    return Double(currentWeather.humidity ?? 0)
                case .pressure:
                    return currentWeather.pressureIn ?? 0
                case .visibility:
                    return currentWeather.visKM ?? 0
                case .none:
                    return 0
                }
            }
            .eraseToAnyPublisher()
    }
    
    @Published private var weather: CurrentWeather?
    private let detailsType: WeatherDetails
    
    //MARK: - Initialization
    
    init(weather: CurrentWeather?, detailsType: WeatherDetails) {
        self.weather = weather
        self.detailsType = detailsType
    }
    
}
