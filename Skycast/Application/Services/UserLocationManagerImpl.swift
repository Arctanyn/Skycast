//
//  UserLocationManagerImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation
import Combine
import CoreLocation

final class UserLocationManagerImpl: NSObject, UserLocationManager {
    
    var locationPublisher: AnyPublisher<CLLocation?, Never> {
        $lastLocations
            .map { $0.first }
            .eraseToAnyPublisher()
    }
    
    var errorSubject: PassthroughSubject<Error?, Never> = PassthroughSubject()
    
    @Published private var lastLocations: [CLLocation] = []
    
    private var manager = CLLocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    func updateLocation() {
        manager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
    }
}

//MARK: - Private methods

private extension UserLocationManagerImpl {
    func setupLocationManager() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
    }
}

//MARK: - CLLocationManagerDelegate

extension UserLocationManagerImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastLocations = locations
        stopUpdating()
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        errorSubject.send(error)
        stopUpdating()
    }
}
