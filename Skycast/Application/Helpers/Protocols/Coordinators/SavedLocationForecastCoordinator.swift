//
//  SavedLocationForecastCoordinator.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

protocol SavedLocationForecastCoordinator: Coordinator {
    var finishFlow: VoidClosure? { get set }
    func dismissModule()
}
