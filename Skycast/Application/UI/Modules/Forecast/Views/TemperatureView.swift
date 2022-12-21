//
//  TemperatureView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 21.12.2022.
//

import UIKit

final class TemperatureView: BaseView {
    
    //MARK: - Views
    
    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 5,
        distribution: .fillProportionally,
        alignment: .center,
        arrangedSubviews: [degreesLabel, titleLabel]
    )
    
    private lazy var titleLabel = UILabel(
        textColor: Resources.Colors.darkText,
        font: Resources.Fonts.system(size: 18, weight: .semibold)
    )
    private lazy var degreesLabel = UILabel(
        textColor: Resources.Colors.blue,
        font: Resources.Fonts.system(size: 40, weight: .bold)
    )
    
    //MARK: - Initialization
    
    init(title: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        titleLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func setupViews(withTemperature temprature: Temperature) {
        degreesLabel.text = temprature.stringFormat
    }
    
    override func setupViews() {
        addSubview(mainVStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            mainVStack.topAnchor.constraint(equalTo: topAnchor),
            mainVStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
