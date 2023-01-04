//
//  SavedLocationForecastCoordinatorImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

final class SavedLocationForecastCoordinatorImpl: BaseCoordinator, SavedLocationForecastCoordinator {

    //MARK: Properties
    
    var finishFlow: VoidClosure?
    
    private let assemblyBuilder: AssemblyBuilder
    private let router: Router
    
    //MARK: - Initialization
    
    init(assemblyBuilder: AssemblyBuilder, router: Router) {
        self.assemblyBuilder = assemblyBuilder
        self.router = router
    }
    
    //MARK: - Methods
    
    override func start(with item: Any?) {
        guard let weather = item as? Weather? else { return }
        let module = assemblyBuilder.createSavedLocationWeatherForecastModule(weather: weather, coordinator: self)
        router.push(module, animated: true)
    }
    
    func finishCurrentFlow() {
        finishFlow?()
    }
    
}
