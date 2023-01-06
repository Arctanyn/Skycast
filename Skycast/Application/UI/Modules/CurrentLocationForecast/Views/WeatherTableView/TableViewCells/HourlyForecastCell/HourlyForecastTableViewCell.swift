//
//  HourlyForecastTableViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 24.12.2022.
//

import UIKit
import Combine

final class HourlyForecastTableViewCell: BaseTableViewCell, ViewModelable {
    
    typealias ViewModel = HourlyForecastCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.conditionPublisher
                .assignToTextOnLabel(conditionLabel)
                .store(in: &cancellables)
            
            viewModel.hourPublisher
                .assignToTextOnLabel(hourLabel)
                .store(in: &cancellables)
            
            viewModel.weatherIconPublisher
                .sink { [weak self] code, dayPeriod in
                    self?.weatherIconImageView.image = Resources.Images.Weather.weatherIcon(
                        code: code,
                        dayPriod: dayPeriod
                    )
                }
                .store(in: &cancellables)
            
            viewModel.temperaturePublisher
                .map { $0.stringFormat }
                .assignToTextOnLabel(temperatureLabel)
                .store(in: &cancellables)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views

    private lazy var mainHStack = UIStackView(
        axis: .horizontal,
        spacing: 20,
        alignment: .center,
        arrangedSubviews: [hourLabel, weatherInfoHStack]
    )
    
    private lazy var hourLabel = UILabel(font: Resources.Fonts.system(weight: .semibold))
    
    private lazy var weatherInfoHStack = UIStackView(
        axis: .horizontal,
        spacing: 20,
        distribution: .fillProportionally,
        alignment: .center,
        arrangedSubviews: [weatherIconImageView, conditionLabel, temperatureLabel]
    )
    
    private lazy var weatherIconImageView = UIImageView(contentMode: .scaleAspectFit)
    
    private lazy var conditionLabel = UILabel(
        font: Resources.Fonts.system(size: 14, weight: .light)
    )
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel(
            textColor: .white,
            font: Resources.Fonts.system(weight: .semibold),
            textAlignment: .center
        )
        label.backgroundColor = .systemIndigo
        label.layer.masksToBounds = true
        return label
    }()
    
    //MARK: - Methods
    
    override func layoutSubviews() {
        temperatureLabel.layer.cornerRadius = temperatureLabel.frame.height / 2
    }

    override func setupViews() {
        contentView.addSubview(mainHStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            hourLabel.widthAnchor.constraint(equalToConstant: 50),
            
            temperatureLabel.widthAnchor.constraint(equalToConstant: 60),
            temperatureLabel.heightAnchor.constraint(equalToConstant: 30),
            
            weatherIconImageView.widthAnchor.constraint(equalToConstant: 25),
            weatherIconImageView.heightAnchor.constraint(equalTo: weatherIconImageView.widthAnchor),
            
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])
    }
}
