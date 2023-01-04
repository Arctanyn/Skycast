//
//  SavedLocationWeatherViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

final class SavedLocationWeatherViewModelImpl: SavedLocationWeatherViewModel {
    
    //MARK: Properties
    
    private let weather: Weather?
    private let coordinator: SavedLocationForecastCoordinator
    
    //MARK: - Initialization
    
    init(weather: Weather?, coordinator: SavedLocationForecastCoordinator) {
        self.weather = weather
        self.coordinator = coordinator
    }
    
    //MARK: - Methods
    
    func viewModelForWeatherForecastView() -> ForecastViewViewModel {
        return ForecastViewViewModelImpl(weather: weather)
    }
    
    func moduleWillDisappear() {
        coordinator.finishFlow?()
    }
}
