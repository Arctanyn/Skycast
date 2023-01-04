//
//  CoordinatorsFactoryImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import Foundation

final class CoordinatorsFactoryImpl: CoordinatorsFactory {

    //MARK: Properties
    
    private let assemblyBuilder: AssemblyBuilder
    
    //MARK: - Initialization
    
    init(assemblyBuilder: AssemblyBuilder) {
        self.assemblyBuilder = assemblyBuilder
    }
    
    //MARK: - Methods
    
    func createApplicationCoordinator(router: Router) -> ApplicationCoordinator {
        return ApplicationCoordinator(assemblyBuilder: assemblyBuilder, coordinatorsFactory: self, router: router)
    }
    
    func createForecastCoordinator(router: Router) -> CurrentLocationForecastCoordinator {
        return CurrentLocationForecastCoordinatorImpl(assemblyBuilder: assemblyBuilder, coordinatorsFactory: self, router: router)
    }

    func createMyLocationsCoordinator(router: Router) -> MyLocationsCoordinator {
        return MyLocationsCoordinatorImpl(assemblyBuilder: assemblyBuilder, coordinatorsFactory: self, router: router)
    }
    
    func createLocationForecastCoordinator(router: Router) -> LocationForecastCoordinator {
        return LocationForecastCoordinatorImpl(assemblyBuilder: assemblyBuilder, router: router)
    }
    
    func createSavedLocationForecastCoordinator(router: Router) -> SavedLocationForecastCoordinator {
        return SavedLocationForecastCoordinatorImpl(assemblyBuilder: assemblyBuilder, router: router)
    }
}
