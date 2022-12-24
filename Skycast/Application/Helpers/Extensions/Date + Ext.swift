//
//  Date + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 23.12.2022.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter.createLocaledFormatter(dateFormat: format)
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func convertToWeekday() -> String {
        toString(format: DateFormat.weekday.rawValue)
    }
}
