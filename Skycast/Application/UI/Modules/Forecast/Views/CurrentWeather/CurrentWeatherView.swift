//
//  CurrentWeatherView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import UIKit
import Combine

final class CurrentWeatherView: BaseView, ViewModelable {
    
    typealias ViewModel = CurrentWeatherViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.temperaturePublisher
                .mapToTemperature(in: .celsius)
                .assignToTextOnLabel(temperatureLabel)
                .store(in: &cancellables)
            
            viewModel.conditionPublisher
                .assignToTextOnLabel(conditionLabel)
                .store(in: &cancellables)
            
            viewModel.locationPublisher
                .assignToTextOnLabel(locationLabel)
                .store(in: &cancellables)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var labelsVStack = UIStackView(axis: .vertical, spacing: 0)
    private lazy var mainHStack = UIStackView(axis: .horizontal, spacing: 10)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Resources.Strings.currentWeatherTitle
        label.font = Resources.Fonts.system(size: 17, weight: .semibold)
        label.textColor = Resources.Colors.title
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.Fonts.system(size: 40, weight: .bold)
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.font = Resources.Fonts.system(size: 16, weight: .medium)
        label.textColor = Resources.Colors.darkText
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = Resources.Fonts.system(size: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var weatherIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: - Lyfecycle
    
    override func layoutSubviews() {
        layer.cornerRadius = 20
        addShadow()
    }
    
    //MARK: - Methods
    
    override func configureAppearance() {
        backgroundColor = Resources.Colors.background
    }
    
    override func setupViews() {
        addSubview(titleLabel, useAutoLayout: true)
        addSubview(locationLabel, useAutoLayout: true)
        setupLabelsVStack()
        setupMainHStack()
    }
    
    override func constraintViews() {
        weatherIconView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            weatherIconView.widthAnchor.constraint(equalToConstant: 80),
                                    
            mainHStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            mainHStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            mainHStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            locationLabel.topAnchor.constraint(equalTo: mainHStack.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            locationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
}

//MARK: - Private methods

private extension CurrentWeatherView {
    func setupLabelsVStack() {
        addSubview(labelsVStack, useAutoLayout: true)
        labelsVStack.addArrangedSubviews([
            temperatureLabel,
            conditionLabel
        ])
    }
    
    func setupMainHStack() {
        addSubview(mainHStack, useAutoLayout: true)
        mainHStack.addArrangedSubviews([
            labelsVStack,
            weatherIconView
        ])
    }
    
    func addShadow() {
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize(width: 0, height: 7)
    }
}
