//
//  LocationForecastViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import Foundation
import Combine

protocol LocationForecastViewModel {
    var isCityInMyLocations: Bool { get }
    var weatherRecievedPublisher: AnyPublisher<Bool, Never> { get }
    func viewModelForWeatherForecastView() -> ForecastViewViewModel
    func getWeatherForecast()
    func addCityToMyLocations()
    func dismissPage()
    func moduleWillDisappear()
}
