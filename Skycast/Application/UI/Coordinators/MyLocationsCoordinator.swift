//
//  MyLocationsCoordinator.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 29.12.2022.
//

import Foundation

final class MyLocationsCoordinator: BaseCoordinator {
    
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
    
    override func start() {
        router.setRootModule(assemblyBuilder.createMyLocationsModule(), hideBar: false)
    }

}
