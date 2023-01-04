//
//  DailyForecastCellViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 23.12.2022.
//

import Foundation
import Combine

protocol DailyForecastCellViewModel {
    var weatherCodePublisher: AnyPublisher<Int, Never> { get }
    var weekdayPublisher: AnyPublisher<String, Never> { get }
    var temperaturesPublisher: AnyPublisher<(low: Temperature, high: Temperature), Never> { get }
}

