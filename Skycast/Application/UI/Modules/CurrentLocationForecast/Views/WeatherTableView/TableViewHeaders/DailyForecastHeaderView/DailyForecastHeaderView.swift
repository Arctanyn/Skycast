//
//  DailyForecastHeaderView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 23.12.2022.
//

import UIKit

final class DailyForecastHeaderView: BaseView {
    
    //MARK: - Views
    
    private lazy var labelsHStack = UIStackView(
        axis: .horizontal,
        spacing: 20,
        distribution: .fillEqually,
        arrangedSubviews: [lowLabel, hightLabel]
    )
    
    private lazy var lowLabel = UILabel(
        text: "LOW",
        font: Resources.Fonts.system(weight: .semibold),
        textAlignment: .center
    )
    
    private lazy var hightLabel = UILabel(
        text: "HIGH",
        font: Resources.Fonts.system(weight: .semibold),
        textAlignment: .center
    )
    
    //MARK: - Methods
    
    override func setupViews() {
        lowLabel.alpha = 0.6
        addSubview(labelsHStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            labelsHStack.topAnchor.constraint(greaterThanOrEqualTo: topAnchor),
            labelsHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            labelsHStack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
