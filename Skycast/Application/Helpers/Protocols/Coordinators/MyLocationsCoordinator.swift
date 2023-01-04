//
//  MyLocationsCoordinator.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import Foundation

protocol MyLocationsCoordinator: Coordinator {
    var finishFlow: VoidClosure? { get set }
    func showForecastForSearchResult(with city: City)
    func showForecastForCity(with weather: Weather?)
}
