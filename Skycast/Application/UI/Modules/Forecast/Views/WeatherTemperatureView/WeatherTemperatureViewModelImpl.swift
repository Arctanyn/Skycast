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
    
    @Published private var day: Day?
    
    //MARK: - Initialization
    
    init(day: Day?) {
        self.day = day
    }
}
