//
//  CurrentLocationForecastViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation
import Combine

protocol CurrentLocationForecastViewModel {
    var weatherRecievedPublisher: AnyPublisher<Bool, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func updateLocation()
    func viewModelForWeatherForecastView() -> ForecastViewViewModelImpl
}
