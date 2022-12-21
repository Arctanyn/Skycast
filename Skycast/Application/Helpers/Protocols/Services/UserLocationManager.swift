//
//  UserLocationManager.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation
import Combine
import CoreLocation

protocol UserLocationManager {
    var locationPublisher: AnyPublisher<CLLocation, Never> { get }
    var errorSubject: PassthroughSubject<LocationError, Never> { get }
    func updateLocation()
}
