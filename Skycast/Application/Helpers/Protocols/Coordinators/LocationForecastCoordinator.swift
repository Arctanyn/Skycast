//
//  LocationForecastCoordinator.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import Foundation

protocol LocationForecastCoordinator: AnyObject {
    func finishCurrentFlow()
    func dismissModule()
}
