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
    
    var minTemperaturePublisher: AnyPublisher<Int, Never> {
        $day
            .compactMap { $0?.mintempC }
            .map { $0.toRoundedInt }
            .eraseToAnyPublisher()
    }
    
    var maxTemperaturePublisher: AnyPublisher<Int, Never> {
        $day
            .compactMap { $0?.maxtempC }
            .map { $0.toRoundedInt }
            .eraseToAnyPublisher()
    }
    
    //MARK: - Initialization
    
    init(day: Day?) {
        self.day = day
    }
}
