//
//  CurrentLocationForecastCoordinator.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

protocol CurrentLocationForecastCoordinator: Coordinator {
    var finishFlow: VoidClosure? { get set }
}
