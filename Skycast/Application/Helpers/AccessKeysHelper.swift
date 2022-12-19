//
//  AccessKeysHelper.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import Foundation

struct AccessKeysHelper {
    
    enum KeyType {
        case weatherApiKey
        
        var dictionaryKey: String {
            switch self {
            case .weatherApiKey:
                return "Weather API Key"
            }
        }
    }

    func getKey(type: KeyType) -> String? {
        guard let path = Bundle.main.path(forResource: "Info", ofType: ".plist") else { return nil }
        do {
            let dictionary = try NSDictionary(contentsOf: URL(filePath: path), error: ())
            return dictionary.object(forKey: type.dictionaryKey) as? String
        } catch {
            fatalError("Unable to access the requested key")
        }
    }
}
