//
//  AssemblyBuilderImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

final class AssemblyBuilderImpl: AssemblyBuilder {
    func createHomeModule() -> UIViewController {
        return ForecastViewController()
    }
}
