//
//  UIStackView + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import UIKit

extension UIStackView {
    
    //MARK: Initialization
    
    convenience init(axis: NSLayoutConstraint.Axis,
                     spacing: CGFloat = 0,
                     distribution: UIStackView.Distribution = .fill,
                     alignment: Alignment = .fill,
                     arrangedSubviews: [UIView] = []) {
        self.init()
        self.axis = axis
        self.spacing = spacing
        self.distribution = distribution
        self.alignment = alignment
        self.addArrangedSubviews(arrangedSubviews)
    }
    
    //MARK: - Methods
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0) }
    }
}
