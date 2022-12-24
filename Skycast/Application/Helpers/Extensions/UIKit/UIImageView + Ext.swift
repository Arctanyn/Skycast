//
//  UIImageView + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 24.12.2022.
//

import UIKit

extension UIImageView {
    convenience init(image: UIImage? = nil, tintColor: UIColor = .systemBlue, contentMode: UIView.ContentMode = .scaleToFill) {
        self.init(image: image)
        self.tintColor = tintColor
        self.contentMode = contentMode
    }
}
