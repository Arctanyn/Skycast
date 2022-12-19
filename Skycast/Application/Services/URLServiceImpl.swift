//
//  URLServiceImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation

struct URLServiceImpl: URLService {
    func createURL(scheme: String, host: String, path: String, queryParameters: [String : String]?) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryParameters?.map { URLQueryItem(name: $0, value: $1) }
        return urlComponents.url
    }
}
