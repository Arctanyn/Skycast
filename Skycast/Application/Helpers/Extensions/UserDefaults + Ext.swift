//
//  UserDefaults + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

extension UserDefaults {
    
    func saveCities(_ cities: [City]) {
        do {
            let data = try JSONEncoder().encode(cities)
            set(data, forKey: UserDefaultsKeys.cities)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchCities() -> [City]? {
        guard let data = self.data(forKey: UserDefaultsKeys.cities) else {
            return nil
        }
        return try? JSONDecoder().decode([City].self, from: data)
    }
    
    func saveBackgroundModeEnteringTime(_ date: Date) {
        setValue(date, forKey: UserDefaultsKeys.timeInBackground)
    }
    
    func getBackgroundModeEnteringTime() -> Date? {
        object(forKey: UserDefaultsKeys.timeInBackground) as? Date
    }
}
