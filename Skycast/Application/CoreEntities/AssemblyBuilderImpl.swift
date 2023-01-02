//
//  AssemblyBuilderImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

final class AssemblyBuilderImpl: AssemblyBuilder {
    
    //MARK: Properties
    
    weak var di: DI!
    
    //MARK: - Methods
    
    func createForecastModule() -> UIViewController {
        let view = ForecastViewController()

        let viewModel = ForecastViewModelImpl(
            locationManager: di.userLocationManager,
            weatherService: di.weatherAPIService
        )
        view.viewModel = viewModel
        
        return view
    }
    
    func createMyLocationsModule(coordinator: MyLocationsCoordinator) -> UIViewController {
        let view = MyLocationsViewController()
        
        let viewModel = MyLocationsViewModelImpl(weatherService: di.weatherAPIService, coordinator: coordinator)
        view.viewModel = viewModel
        
        return view
    }
    
    func createLocationForecastModule(city: City, coordinator: LocationForecastCoordinator) -> UIViewController {
        let view = LocationForecastViewController()
        
        let viewModel = LocationForecastViewModelImpl(
            city: city,
            weatherService: di.weatherAPIService,
            coodinator: coordinator
        )
        view.viewModel = viewModel
        
        return view
    }
}
