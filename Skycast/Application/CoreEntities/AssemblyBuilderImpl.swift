//
//  AssemblyBuilderImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

final class AssemblyBuilderImpl: AssemblyBuilder {
    weak var di: DI!
    
    func createHomeModule() -> UIViewController {
        let view = ForecastViewController()

        let viewModel = ForecastViewModelImpl(
            locationManager: di.userLocationManager,
            weatherService: di.weatherAPIService
        )
        view.viewModel = viewModel
        
        return view
    }
}
