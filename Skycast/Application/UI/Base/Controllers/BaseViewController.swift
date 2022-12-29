//
//  BaseViewController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    //MARK: - View Controller Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        setupViews()
        constraintViews()
    }
}

//MARK: - BaseViewSetup

@objc extension BaseViewController: BaseViewSetup {
    func configureAppearance() {
        view.backgroundColor = Resources.Colors.background
    }
    
    func setupViews() { }
    
    func constraintViews() { }
}

