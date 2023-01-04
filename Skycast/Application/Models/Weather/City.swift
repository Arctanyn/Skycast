//
//  City.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import Foundation

struct City: Decodable, Equatable {
    let id: Int?
    let name: String?
    let region: String?
    let country: String?
    let lat: Double?
    let lon: Double?
    let url: String?
}

