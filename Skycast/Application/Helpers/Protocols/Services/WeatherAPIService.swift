//
//  WeatherAPIService.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation
import CoreLocation
import Combine

protocol WeatherAPIService {
    func getForecast(for location: CLLocationCoordinate2D) throws -> AnyPublisher<Weather, HTTPError>
    func getForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) throws -> AnyPublisher<Weather, HTTPError>
    func searchCity(query: String) throws -> AnyPublisher<[City], HTTPError>
}
