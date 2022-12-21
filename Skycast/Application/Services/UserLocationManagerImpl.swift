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
    
    //MARK: Properties
    
    @Published private var currentLocation: CLLocation?
    
    var locationPublisher: AnyPublisher<CLLocation, Never> {
        $currentLocation
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    var errorSubject: PassthroughSubject<LocationError, Never> = PassthroughSubject()

    private var locationManager = CLLocationManager()
    
    //MARK: - Initialization
    
    override init() {
        super.init()
        setupLocationManager()
    }
    
    //MARK: - Methods
    
    func updateLocation() {
        locationManager.requestLocation()
    }
}

//MARK: - Private methods

private extension UserLocationManagerImpl {
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
}

//MARK: - CLLocationManagerDelegate

extension UserLocationManagerImpl: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorSubject.send(LocationError.failedToGetLocation)
    }
}
