//
//  NotificationName + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation

extension Notification.Name {
    static var addCityToMyLocation: Notification.Name {
        return .init("addCityToMyLocations")
    }
    
    static var updateAfterBackground: Notification.Name {
        return .init("updateAfterBackground")
    }
}
