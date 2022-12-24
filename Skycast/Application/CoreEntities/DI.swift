//
//  DI.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

//MARK: DI

final class DI {
    fileprivate let assemblyBuilder: AssemblyBuilderImpl
    fileprivate let coordinatorsFactory: CoordinatorsFactory
    let userLocationManager: UserLocationManager
    let urlService: URLService
    fileprivate let weatherJSONDecoder: JSONDecoder
    fileprivate let accessKeysHelper: AccessKeysHelper
    let weatherAPIService: WeatherAPIService
    
    init() {
        assemblyBuilder = AssemblyBuilderImpl()
        coordinatorsFactory = CoordinatorsFactoryImpl(assemblyBuilder: assemblyBuilder)
        userLocationManager = UserLocationManagerImpl()
        urlService = URLServiceImpl()
        accessKeysHelper = AccessKeysHelper()
        weatherJSONDecoder = JSONDecoder()
        weatherAPIService = WeatherAPIServiceImpl(
            decoder: weatherJSONDecoder,
            service: urlService,
            accessKeysHelper: accessKeysHelper
        )
        assemblyBuilder.di = self
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
