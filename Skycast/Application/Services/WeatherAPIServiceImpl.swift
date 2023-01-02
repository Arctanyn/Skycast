//
//  WeatherAPIServiceImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation
import CoreLocation
import Combine

final class WeatherAPIServiceImpl: WeatherAPIService {
    
    enum URLError: LocalizedError {
        case invalidURL
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid address of the requested resource"
            }
        }
    }
    
    //MARK: Properties
    
    private let session = URLSession.shared
    private let decoder: JSONDecoder
    private let service: URLService
    private var accessKey: String
    
    //MARK: - Initialization
    
    init(decoder: JSONDecoder, service: URLService, accessKeysHelper: AccessKeysHelper) {
        guard let key = accessKeysHelper.getKey(type: .weatherApiKey) else {
            fatalError("You must have an API key to access the data")
        }
        self.accessKey = key
        self.decoder = decoder
        self.service = service
    }
    
    //MARK: - Methods
    
    func getForecast(for location: CLLocationCoordinate2D) throws -> AnyPublisher<Weather, HTTPError> {
        try getForecast(latitude: location.latitude, longitude: location.longitude)
    }
    
    func getForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) throws -> AnyPublisher<Weather, HTTPError> {
        guard let url = service.createURL(
            scheme: WeatherHTTPBase.scheme,
            host: WeatherHTTPBase.host,
            path: WeatherAPIRoute.forecast.path,
            queryParameters: prepareForecastQueryParameters(coordinate: (latitude, longitude), days: 3)
        ) else {
            throw URLError.invalidURL
        }
                        
        return createNetworkCallPublisher(withOutputType: Weather.self, url: url)
    }
    
    func searchCity(query: String) throws -> AnyPublisher<[City], HTTPError> {
        guard let url = service.createURL(
            scheme: WeatherHTTPBase.scheme,
            host: WeatherHTTPBase.host,
            path: WeatherAPIRoute.search.path,
            queryParameters: prepareSearchQueryParameters(query: query)
        ) else {
            throw URLError.invalidURL
        }
        
        return createNetworkCallPublisher(withOutputType: [City].self, url: url)
    }
}

//MARK: - Private methods

private extension WeatherAPIServiceImpl {
    func createNetworkCallPublisher<T: Decodable>(withOutputType outputType: T.Type, url: URL) -> AnyPublisher<T, HTTPError> {
        session.dataTaskPublisher(for: url)
            .assumeHTTP()
            .map { $0.data }
            .decode(type: outputType.self, decoder: decoder)
            .mapHTTPError()
            .eraseToAnyPublisher()
    }
    
    func prepareForecastQueryParameters(coordinate: (latitude: CLLocationDegrees, longitude: CLLocationDegrees),
                                        days: Int) -> [String: String] {
        return [
            "q": "\(coordinate.latitude) \(coordinate.longitude)",
            "key": accessKey,
            "days": String(days),
            "aqi": "yes",
        ]
    }
    
    func prepareSearchQueryParameters(query: String) -> [String: String] {
        return [
            "q": query,
            "key": accessKey
        ]
    }
}
