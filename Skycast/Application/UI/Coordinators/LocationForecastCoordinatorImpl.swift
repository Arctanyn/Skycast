//
//  LocationForecastCoordinatorImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import Foundation

final class LocationForecastCoordinatorImpl: BaseCoordinator, LocationForecastCoordinator {

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
        guard let city = item as? City else { return }
        let module = assemblyBuilder.createLocationForecastModule(city: city, coordinator: self)
        router.presentInNavigation(module, animated: true, fullScreen: false)
    }

    func dismissModule() {
        finishFlow?()
        router.dismiss(animated: true)
    }
}
