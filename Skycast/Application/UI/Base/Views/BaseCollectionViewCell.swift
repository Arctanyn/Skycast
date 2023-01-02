//
//  BaseCollectionViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import UIKit

class BaseCollectionViewCell: UICollectionViewCell {
    
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

@objc extension BaseCollectionViewCell: BaseViewSetup {
    func configureAppearance() {
        backgroundColor = .clear
    }
    
    func setupViews() { }
    
    func constraintViews() { }
    
    
}
