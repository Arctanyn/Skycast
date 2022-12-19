//
//  Double + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import Foundation

extension Double {
    var toRoundedInt: Int { Int(self.rounded()) }
}
