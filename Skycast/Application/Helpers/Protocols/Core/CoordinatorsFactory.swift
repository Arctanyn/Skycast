//
//  CoordinatorsFactory.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import Foundation

protocol CoordinatorsFactory {
    func createApplicationCoordinator(router: Router) -> ApplicationCoordinator
    func createForecastCoordinator(router: Router) -> CurrentLocationForecastCoordinator
    func createMyLocationsCoordinator(router: Router) -> MyLocationsCoordinator
    func createLocationForecastCoordinator(router: Router) -> LocationForecastCoordinator
    func createSavedLocationForecastCoordinator(router: Router) -> SavedLocationForecastCoordinator
}
