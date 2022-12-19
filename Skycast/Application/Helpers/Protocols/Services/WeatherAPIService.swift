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
    func getWeather(route: WeatherAPIRoute, for location: CLLocation) -> AnyPublisher<Weather, HTTPError>
}
