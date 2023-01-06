//
//  SavedLocationWeatherViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

protocol SavedLocationWeatherViewModel {
    func viewModelForWeatherForecastView() -> ForecastViewViewModel
    func closePage()
}
