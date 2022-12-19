//
//  BaseTableViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 20.12.2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    //MARK: - Initialization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
        setupViews()
        constraintViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - BaseViewSetup

@objc extension BaseTableViewCell: BaseViewSetup {
    func configureAppearance() {
        backgroundColor = .clear
    }
    
    func setupViews() { }
    
    func constraintViews() { }
    
    
}
