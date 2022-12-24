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
    
    func getWeather(route: WeatherAPIRoute, for location: CLLocation) -> AnyPublisher<Weather, HTTPError> {
        guard let url = service.createURL(
            scheme: WeatherHTTPBase.scheme,
            host: WeatherHTTPBase.host,
            path: route.path,
            queryParameters: prepareForecastQueryParameters(coordinate: location.coordinate, days: 3)
        ) else {
            fatalError("Invalid parameters for creating an adress")
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw HTTPError.nonHTTPRequest
                }
                
                let statusCode = httpResponse.statusCode
                
                if case (400..<500) = statusCode {
                    throw HTTPError.requestFailed(statusCode: statusCode)
                } else if case (500..<600) = statusCode {
                    throw HTTPError.serverError(statusCode: statusCode)
                }
                
                return data
            }
            .decode(type: Weather.self, decoder: decoder)
            .mapError { error in
                switch error {
                case is HTTPError:
                    return error as! HTTPError
                case is DecodingError:
                    return HTTPError.decodingError(error as! DecodingError)
                default:
                    return HTTPError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}

//MARK: - Private methods

private extension WeatherAPIServiceImpl {
    func prepareForecastQueryParameters(coordinate: CLLocationCoordinate2D, days: Int) -> [String: String] {
        let parameters = [
            "q": "\(coordinate.latitude) \(coordinate.longitude)",
            "key": accessKey,
            "days": String(days),
            "aqi": "yes",
        ]
        return parameters
    }
}
