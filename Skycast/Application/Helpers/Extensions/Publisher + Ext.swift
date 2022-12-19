//
//  Publisher + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import UIKit
import Combine

extension Publisher {
    func assignToTextOnLabel(_ label: UILabel) -> AnyCancellable where Output == String, Failure == Never {
        map { $0 as String? }
            .assign(to: \.text, on: label)
    }
    
    func mapToTemperature(in units: TemperatureUnit) -> AnyPublisher<String, Never> where Output == Int, Failure == Never {
        map { String($0) + units.rawValue }
            .eraseToAnyPublisher()
    }
}
