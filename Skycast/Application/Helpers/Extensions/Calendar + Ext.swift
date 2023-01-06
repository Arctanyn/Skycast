//
//  Calendar + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 06.01.2023.
//

import Foundation

extension Calendar {
    func minutes(from startDate: Date, to endDate: Date) -> Int? {
        return self.dateComponents([.minute], from: startDate, to: endDate).minute
    }
}
