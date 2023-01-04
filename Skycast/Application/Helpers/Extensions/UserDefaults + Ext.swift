//
//  UserDefaults + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

extension UserDefaults {
    enum Keys: String {
        case cities
    }
    
    func saveCities(_ cities: [City]) {
        do {
            let data = try JSONEncoder().encode(cities)
            set(data, forKey: Keys.cities.rawValue)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCities() -> [City]? {
        guard let data = self.data(forKey: Keys.cities.rawValue) else {
            return nil
        }
        return try? JSONDecoder().decode([City].self, from: data)
    }
}
