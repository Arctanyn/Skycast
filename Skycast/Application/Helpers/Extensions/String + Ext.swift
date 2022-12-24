//
//  String + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 23.12.2022.
//

import Foundation

extension String {
    func convertToDate(format: String) -> Date? {
        let dateFormatter = DateFormatter.createLocaledFormatter(dateFormat: format)
        return dateFormatter.date(from: self)
    }
}
