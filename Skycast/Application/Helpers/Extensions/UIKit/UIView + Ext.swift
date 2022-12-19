//
//  UIView + Ext.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import UIKit

extension UIView {
    func addSubview(_ view: UIView, useAutoLayout: Bool) {
        view.translatesAutoresizingMaskIntoConstraints = !useAutoLayout
        addSubview(view)
    }
    
    func padded(_ inset: CGFloat) -> UIStackView {
        padded(insets: .init(top: inset, left: inset, bottom: inset, right: inset))
    }
    
    func padded(insets: UIEdgeInsets) -> UIStackView {
        let stack = UIStackView(axis: .vertical, arrangedSubviews: [self])
        stack.layoutMargins = insets
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }
}
