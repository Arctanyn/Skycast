//
//  CoordinatorsFactory.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import Foundation

protocol CoordinatorsFactory {
    func createApplicationCoordinator(router: Router) -> ApplicationCoordinator
    func createForecastCoordinator(router: Router) -> ForecastCoordinator
    func createMyLocationsCoordinator(router: Router) -> MyLocationsCoordinator
}
