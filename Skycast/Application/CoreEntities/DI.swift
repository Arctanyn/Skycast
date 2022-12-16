//
//  DI.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

//MARK: DI

final class DI {
    fileprivate let assemblyBuilder: AssemblyBuilder
    fileprivate let coordinatorsFactory: CoordinatorsFactory
    
    init() {
        assemblyBuilder = AssemblyBuilderImpl()
        coordinatorsFactory = CoordinatorsFactoryImpl(assemblyBuilder: assemblyBuilder)
    }
}

//MARK: - AppFactory

extension DI: AppFactory {
    func makeKeyWindowAndCoordinator(with windowScene: UIWindowScene) -> (UIWindow, Coordinator) {
        let rootNavController = UINavigationController()
        let router = RouterImpl(rootController: rootNavController)
        let coordinator = coordinatorsFactory.createApplicationCoordinator(router: router)
        
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = rootNavController
        window.makeKeyAndVisible()
        
        return (window, coordinator)
    }
}
