//
//  LowHighWeatherTemperaturesView.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 18.12.2022.
//

import UIKit
import Combine

final class LowHighWeatherTemperaturesView: BaseView, ViewModelable {
    
    typealias ViewModel = LowHighWeatherTemperaturesViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            setupTemperatureView(lowTemperatureView, withPublisher: viewModel.minTemperaturePublisher)
            setupTemperatureView(highTemperatureView, withPublisher: viewModel.maxTemperaturePublisher)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var mainHStack: UIStackView = UIStackView(
        axis: .horizontal,
        spacing: 60,
        arrangedSubviews: [lowTemperatureView, highTemperatureView]
    )
    
    private lazy var lowTemperatureView: TemperatureView = {
        let temperatureView = TemperatureView(title: "LOW")
        temperatureView.alpha = 0.6
        return temperatureView
    }()
    
    private lazy var highTemperatureView = TemperatureView(title: "HIGH")
    
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

//MARK: - Private methods

private extension LowHighWeatherTemperaturesView {
    func setupTemperatureView<P: Publisher>(_ view: TemperatureView, withPublisher publisher: P) where P.Output == Temperature, P.Failure == Never {
        publisher
            .sink { view.setupViews(withTemperature: $0) }
            .store(in: &cancellables)
    }
}
