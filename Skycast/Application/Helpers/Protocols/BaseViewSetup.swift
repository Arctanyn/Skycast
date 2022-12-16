//
//  BaseViewSetup.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

protocol BaseViewSetup: AnyObject {
    func configureAppearance()
    func setupViews()
    func constraintViews()
}
