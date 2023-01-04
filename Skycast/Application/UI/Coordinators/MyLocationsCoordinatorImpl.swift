//
//  MyLocationsCoordinatorImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 29.12.2022.
//

import Foundation

final class MyLocationsCoordinatorImpl: BaseCoordinator, MyLocationsCoordinator {
    
    //MARK: Properties
    
    var finishFlow: VoidClosure?
    
    private let assemblyBuilder: AssemblyBuilder
    private let coordinatorsFactory: CoordinatorsFactory
    private let router: Router
    
    //MARK: - Initialization
    
    init(assemblyBuilder: AssemblyBuilder, coordinatorsFactory: CoordinatorsFactory, router: Router) {
        self.assemblyBuilder = assemblyBuilder
        self.coordinatorsFactory = coordinatorsFactory
        self.router = router
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        let module = assemblyBuilder.createMyLocationsModule(coordinator: self)
        router.setRootModule(module, hideBar: false)
    }
    
    func showForecastForSearchResult(with city: City) {
        let coordinator = coordinatorsFactory.createLocationForecastCoordinator(router: router)
        coordinator.finishFlow = { [weak self] in
            self?.childDidFinish(coordinator as Coordinator)
        }
        coordinator.start(with: city)
    }
    
    func showForecastForCity(with weather: Weather?) {
        let coordinator = coordinatorsFactory.createSavedLocationForecastCoordinator(router: router)
        coordinator.finishFlow = { [weak self] in
            self?.childDidFinish(coordinator as Coordinator)
        }
        coordinator.start(with: weather)
    }
    

}
