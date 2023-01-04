//
//  AssemblyBuilder.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

protocol AssemblyBuilder {
    func createCurrentLocationForecastModule() -> UIViewController
    func createMyLocationsModule(coordinator: MyLocationsCoordinator) -> UIViewController
    func createLocationForecastModule(city: City, coordinator: LocationForecastCoordinator) -> UIViewController
    func createSavedLocationWeatherForecastModule(weather: Weather?, coordinator: SavedLocationForecastCoordinator) -> UIViewController
}
