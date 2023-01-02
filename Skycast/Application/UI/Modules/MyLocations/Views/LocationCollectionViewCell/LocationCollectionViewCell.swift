//
//  LocationCollectionViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import UIKit

class LocationCollectionViewCell: BaseCollectionViewCell {
    
    //MARK: - Views
    
    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 5,
        distribution: .fillProportionally,
        arrangedSubviews: [locationLabel, mainHStack, conditionLabel, lowHighTemperatureHStack]
    )
    
    private lazy var mainHStack = UIStackView(
        axis: .horizontal,
        distribution: .fillProportionally,
        arrangedSubviews: [temperatureLabel, weatherIconImageView]
    )
    
    private lazy var lowHighTemperatureHStack = UIStackView(
        axis: .horizontal,
        spacing: 10,
        arrangedSubviews: [highTemperatureLabel, lowTemperatureLabel]
    )
    
    private lazy var locationLabel = UILabel(
        text: "London",
        font: Resources.Fonts.system(size: 19, weight: .bold)
    )
    
    private lazy var temperatureLabel = UILabel(
        text: "-3ºC",
        font: Resources.Fonts.system(size: 35, weight: .medium)
    )
    
    private lazy var weatherIconImageView = UIImageView(image: Resources.Images.Weather.sun, tintColor: .white, contentMode: .scaleAspectFit)
    
    private lazy var conditionLabel = UILabel(
        text: "Partly cloudy",
        textColor: .lightText,
        font: Resources.Fonts.system(size: 14, weight: .medium)
    )
    
    private lazy var lowTemperatureLabel = UILabel(
        text: "L: -5º",
        textColor: Resources.Colors.darkText,
        font: Resources.Fonts.system(size: 14),
        textAlignment: .left
    )
    
    private lazy var highTemperatureLabel = UILabel(
        text: "H: 2º",
        textColor: Resources.Colors.darkText,
        font: Resources.Fonts.system(size: 14),
        textAlignment: .left
    )
    
    
    //MARK: - Layout
    
    override func layoutSubviews() {
        layer.cornerRadius = frame.height / 10
        addShadow()
    }
    
    //MARK: - Methods
    
    override func configureAppearance() {
        backgroundColor = Resources.Colors.secondaryBackground
    }
    
    override func setupViews() {
        contentView.addSubview(mainVStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        highTemperatureLabel.setContentHuggingPriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
            weatherIconImageView.heightAnchor.constraint(equalTo: temperatureLabel.heightAnchor),
            weatherIconImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
        ])
    }
}

//MARK: - Private methods

private extension LocationCollectionViewCell {
    func addShadow() {
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.6
        layer.shadowPath = UIBezierPath(
            roundedRect: CGRect(
                x: 0,
                y: 5,
                width: frame.width,
                height: frame.height
            ),
            cornerRadius: layer.cornerRadius
        ).cgPath
    }
}
