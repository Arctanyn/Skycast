//
//  WeatherDetailsCellViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 19.12.2022.
//

import Foundation
import Combine

protocol WeatherDetailsCellViewModel {
    var type: WeatherDetails { get }
    var title: String { get }
    var value: Double { get }
    var valuePublisher: AnyPublisher<Double, Never> { get }
}
