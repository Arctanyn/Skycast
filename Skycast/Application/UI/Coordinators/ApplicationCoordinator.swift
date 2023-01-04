//
//  ApplicationCoordinator.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 29.12.2022.
//

import UIKit

final class ApplicationCoordinator: BaseCoordinator {
    
    //MARK: Properties
    
    private let tabBarController = MainTabBarController()
    private var navigationControllers = [UINavigationController]()
    
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
        prepareTabs()
        tabBarController.configureViewControllers(navigationControllers)
        router.setRootModule(tabBarController, hideBar: true)
    }
    
    //MARK: - Private methods
    
    private func prepareTabs() {
        Tabs.allCases.forEach { setupCoordinator(for: $0) }
        childCoordinators.forEach { $0.start(with: nil) }
    }
    
    private func setupCoordinator(for tab: Tabs) {
        let navigationController = UINavigationController()
        navigationController.tabBarItem.tag = tab.rawValue
        navigationControllers.append(navigationController)
        let router = RouterImpl(rootController: navigationController)

        switch tab {
        case .forecast:
            let coordinator = coordinatorsFactory.createForecastCoordinator(router: router)
            coordinator.finishFlow = { [weak self] in
                self?.childDidFinish(coordinator)
            }
            addChild(coordinator)
        case .myLocations:
            let coordinator = coordinatorsFactory.createMyLocationsCoordinator(router: router)
            
            coordinator.finishFlow = { [weak self] in
                self?.childDidFinish(coordinator as Coordinator)
            }
            addChild(coordinator)
        }
    }
}
