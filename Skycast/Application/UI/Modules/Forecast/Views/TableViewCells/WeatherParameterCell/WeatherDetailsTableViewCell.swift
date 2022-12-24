//
//  WeatherDetailsTableViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import UIKit
import Combine

final class WeatherDetailsTableViewCell: BaseTableViewCell, ViewModelable {
    
    typealias ViewModel = WeatherDetailsCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            iconImageView.image = viewModel.type.icon
            titleLabel.text = "\(viewModel.title)"
            
            viewModel.valuePublisher
                .sink { [weak self] value in
                    guard let self else { return }
                    self.displayValueLabel(with: value, for: self.viewModel.type)
                }
                .store(in: &cancellables)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var iconImageView = UIImageView(
        tintColor: Resources.Colors.darkText,
        contentMode: .scaleAspectFit
    )
    
    private lazy var titleLabel = UILabel(
        textColor: Resources.Colors.darkText,
        font: Resources.Fonts.system(size: 14, weight: .semibold)
    )
    
    private lazy var valueLabel = UILabel(
        textColor: Resources.Colors.darkText,
        font: Resources.Fonts.system(size: 13, weight: .light)
    )
    
    //MARK: - Methods
    
    override func setupViews() {
        contentView.addSubview(iconImageView, useAutoLayout: true)
        contentView.addSubview(titleLabel, useAutoLayout: true)
        contentView.addSubview(valueLabel, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: 20),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        let iconBottomConstraint = iconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        iconBottomConstraint.priority = .defaultLow
        iconBottomConstraint.isActive = true
    }
    
}

//MARK: - Private methods

private extension WeatherDetailsTableViewCell {
    func displayValueLabel(with value: Double, for detailsType: WeatherDetails) {
        var text = String()
        
        switch detailsType {
        case .wind:
            text = "\(value) Km/h"
        case .humidity:
            text = "\(value.toRoundedInt)%"
        case .pressure:
            text = "\(value.toRoundedInt)º"
        case .visibility:
            text = "\(value) Km"
        case .uvIndex:
            text = "\(value.toRoundedInt)"
        }
        
        valueLabel.text = text
    }
}
