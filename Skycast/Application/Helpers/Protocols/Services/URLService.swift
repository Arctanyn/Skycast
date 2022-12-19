//
//  URLService.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation

protocol URLService {
    func createURL(scheme: String, host: String, path: String, queryParameters: [String: String]?) -> URL?
}
