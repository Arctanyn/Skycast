//
//  BaseCoordinator.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 29.12.2022.
//

import Foundation

class BaseCoordinator: Coordinator {
    
    //MARK: Properties
    
    var childCoordinators: [Coordinator] = []
    
    //MARK: - Methods
    
    func start() {
        fatalError("No implementation")
    }

    func addChild(_ coordinator: Coordinator) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else { return }
        childCoordinators.append(coordinator)
    }
    
    func childDidFinish(_ coordinator: Coordinator) {
        guard !childCoordinators.isEmpty else { return }
        
        if let coordinator = coordinator as? BaseCoordinator, !coordinator.childCoordinators.isEmpty {
            coordinator.childCoordinators
                .filter { $0 !== coordinator }
                .forEach { coordinator.childDidFinish($0) }
        }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
