//
//  WeatherTemperatureView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import UIKit
import Combine

final class WeatherTemperatureView: BaseView, ViewModelable {
    
    typealias ViewModel = WeatherTemperatureViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.minTemperaturePublisher
                .mapToTemperature(in: .celsius)
                .assignToTextOnLabel(minTempLabel)
                .store(in: &cancellables)
            
            viewModel.maxTemperaturePublisher
                .mapToTemperature(in: .celsius)
                .assignToTextOnLabel(maxTempLabel)
                .store(in: &cancellables)
            
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var mainHStack: UIStackView = {
        let stack = UIStackView(axis: .horizontal, spacing: 40, distribution: .fillEqually)
        stack.addArrangedSubviews([
            minTempStackView,
            maxTempStackView
        ])
        return stack
    }()
    
    private lazy var minTempStackView: UIStackView = {
        let stack = UIStackView(axis: .vertical, spacing: 5, distribution: .fillProportionally, alignment: .center)
        stack.addArrangedSubviews([
            minTempLabel,
            lowLabel
        ])
        return stack
    }()
    
    private lazy var maxTempStackView: UIStackView = {
        let stack = UIStackView(axis: .vertical, spacing: 5, distribution: .fillProportionally, alignment: .center)
        stack.addArrangedSubviews([
            maxTempLabel,
            highLabel
        ])
        return stack
    }()
    
    private lazy var lowLabel = UILabel(
        text: "LOW",
        textColor: .tertiaryLabel,
        font: Resources.Fonts.system(size: 18, weight: .semibold)
    )
    
    private lazy var highLabel = UILabel(
        text: "HIGH",
        textColor: Resources.Colors.darkText,
        font: Resources.Fonts.system(size: 18, weight: .semibold)
    )
    
    private lazy var minTempLabel = UILabel(
        text: "5ºC",
        textColor: Resources.Colors.blue.withAlphaComponent(0.6),
        font: Resources.Fonts.system(size: 35, weight: .bold)
    )
    
    private lazy var maxTempLabel = UILabel(
        text: "20ºC",
        textColor: Resources.Colors.blue,
        font: Resources.Fonts.system(size: 35, weight: .bold)
    )
    
    //MARK: - Methods
    
    override func configureAppearance() {
        backgroundColor = .clear
        
    }
    
    override func setupViews() {
        addSubview(mainHStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            mainHStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            mainHStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainHStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }

}
