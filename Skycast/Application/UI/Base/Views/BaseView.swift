//
//  BaseView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import UIKit

class BaseView: UIView {
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        setupViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - BaseViewSetup

@objc extension BaseView: BaseViewSetup {
    func configureAppearance() { }
    
    func setupViews() { }
    
    func constraintViews() { }
}
