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
    
    @Published private var weather: CurrentWeather?
    
    var type: WeatherDetails {
        return detailsType
    }
    
    var title: String {
        detailsType.rawValue
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
                case .uvIndex:
                    return currentWeather.uv ?? 0
                case .none:
                    return 0
                }
            }
            .eraseToAnyPublisher()
    }
    
    private let detailsType: WeatherDetails
    
    //MARK: - Initialization
    
    init(weather: CurrentWeather?, detailsType: WeatherDetails) {
        self.weather = weather
        self.detailsType = detailsType
    }
    
}
