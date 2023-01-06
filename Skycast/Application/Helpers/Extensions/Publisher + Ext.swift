//
//  Publisher + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import UIKit
import Combine

enum TemperatureType {
    case low
    case high
}


extension Publisher {
    func assumeHTTP() -> AnyPublisher<(data: Data, httpResponse: HTTPURLResponse), Error> where Output == (data: Data, response: URLResponse), Failure == URLError {
        tryMap { data, response in
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPError.nonHTTPRequest
            }
            
            let statusCode = httpResponse.statusCode
            
            if case (400..<500) = statusCode {
                throw HTTPError.requestFailed(statusCode: statusCode)
            } else if case (500..<600) = statusCode {
                throw HTTPError.serverError(statusCode: statusCode)
            }
            
            return (data, httpResponse)
        }
        .eraseToAnyPublisher()
    }
    
    func mapHTTPError() -> Publishers.MapError<Self, HTTPError> {
        mapError { error in
            switch error {
            case is HTTPError:
                return error as! HTTPError
            case is DecodingError:
                return HTTPError.decodingError(error as! DecodingError)
            default:
                return HTTPError.networkError(error)
            }
        }
    }
    
    func assignToTextOnLabel(_ label: UILabel) -> AnyCancellable where Output == String, Failure == Never {
        map { $0 as String? }
            .assign(to: \.text, on: label)
    }

    
    func compactMapToDayPeriod() -> AnyPublisher<DayPeriod, Never> where Output == Int, Failure == Never {
        compactMap {
            DayPeriod(rawValue: $0)
        }
        .eraseToAnyPublisher()
    }
    
    func mapToTemperature(in units: TemperatureUnits) -> AnyPublisher<Temperature, Never> where Output == TemperatureConvertable, Failure == Never {
        compactMap {
            $0.getTemperature(in: units)
        }
        .eraseToAnyPublisher()
    }
    
    
    func mapToTemperature(type: TemperatureType, in units: TemperatureUnits) -> AnyPublisher<Temperature, Never> where Output == Day, Failure == Never {
        compactMap {
            switch units {
            case .celsius:
                return (type == .low ? $0.mintempC : $0.maxtempC)?.convertToTemperature(in: units)
            case .fahrenheit:
                return (type == .low ? $0.mintempF : $0.maxtempF)?.convertToTemperature(in: units)
            }
        }
        .eraseToAnyPublisher()
    }
    
}

