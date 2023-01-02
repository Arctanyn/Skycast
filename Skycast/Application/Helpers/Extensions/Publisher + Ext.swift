//
//  Publisher + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import UIKit
import Combine

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
    
    func mapToTemperature(in units: TemperatureUnits) -> AnyPublisher<Temperature, Never> where Output == Int, Failure == Never {
        map { Temperature(degrees: $0, units: units) }
            .eraseToAnyPublisher()
    }
    
    func compactMapToDayPeriod() -> AnyPublisher<DayPeriod, Never> where Output == Int, Failure == Never {
        compactMap {
            DayPeriod(rawValue: $0)
        }
        .eraseToAnyPublisher()
    }
}

