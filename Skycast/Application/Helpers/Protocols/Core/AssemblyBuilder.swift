//
//  AssemblyBuilder.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

protocol AssemblyBuilder {
    func createForecastModule() -> UIViewController
    func createMyLocationsModule() -> UIViewController
}
