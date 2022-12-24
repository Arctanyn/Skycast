//
//  DailyForecastTableViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 23.12.2022.
//

import UIKit
import Combine

final class DailyForecastTableViewCell: BaseTableViewCell, ViewModelable {
    
    typealias ViewModel = DailyForecastCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.temperaturesPublisher
                .sink { [weak self] lowTemperature, highTemperature in
                    self?.lowTemperatureLabel.text = lowTemperature.stringFormat
                    self?.highTemperatureLabel.text = highTemperature.stringFormat
                }
                .store(in: &cancellables)
            
            viewModel.weekdayPublisher
                .assignToTextOnLabel(weekdayLabel)
                .store(in: &cancellables)
            
            viewModel.weatherCodePublisher
                .sink { [weak self] code in
                    self?.weatherIconManager.setIcon(code: code, dayTime: .day)
                }
                .store(in: &cancellables)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let weatherIconManager = WeatherIconManager()
    
    //MARK: - Views
    
    private lazy var mainHStack = UIStackView(
        axis: .horizontal,
        spacing: 10,
        distribution: .fillEqually,
        alignment: .center,
        arrangedSubviews: [weekdayLabel, weatherIconImageView, temperaturesHStack]
    )
    
    private lazy var weekdayLabel = UILabel(font: Resources.Fonts.system(weight: .semibold))
    
    private lazy var weatherIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var temperaturesHStack = UIStackView(
        axis: .horizontal,
        spacing: 20,
        distribution: .fillEqually,
        arrangedSubviews: [lowTemperatureLabel, highTemperatureLabel]
    )
    
    private lazy var lowTemperatureLabel = UILabel(
        font: Resources.Fonts.system(weight: .semibold),
        textAlignment: .center
    )
    
    private lazy var highTemperatureLabel = UILabel(
        font: Resources.Fonts.system(weight: .semibold),
        textAlignment: .center
    )
    
    //MARK: - Methods
    
    func changeLabelsColor(to color: UIColor) {
        [weekdayLabel, lowTemperatureLabel, highTemperatureLabel].forEach { label in
            label.textColor = color
        }
    }
    
    override func configureAppearance() {
        backgroundColor = .clear
        
        weatherIconManager.$icon
            .assign(to: \.image, on: weatherIconImageView)
            .store(in: &cancellables)
    }
    
    override func setupViews() {
        lowTemperatureLabel.alpha = 0.6
        contentView.addSubview(mainHStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            mainHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainHStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            mainHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
