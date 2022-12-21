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
            setupTemperatureView(minTemperatureView, withPublisher: viewModel.minTemperaturePublisher)
            
            setupTemperatureView(maxTemperatureView, withPublisher: viewModel.maxTemperaturePublisher)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var mainHStack: UIStackView = UIStackView(
        axis: .horizontal,
        spacing: 60,
        arrangedSubviews: [minTemperatureView, maxTemperatureView]
    )
    
    private lazy var minTemperatureView: TemperatureView = {
        let temperatureView = TemperatureView(title: "LOW")
        temperatureView.alpha = 0.6
        return temperatureView
    }()
    
    private lazy var maxTemperatureView = TemperatureView(title: "HIGH")
    
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

private extension WeatherTemperatureView {
    func setupTemperatureView<P: Publisher>(_ view: TemperatureView, withPublisher publisher: P) where P.Output == Int, P.Failure == Never {
        publisher
            .mapToTemperature(in: .celsius)
            .sink { temperature in
                view.setupViews(withTemperature: temperature)
            }
            .store(in: &cancellables)
    }
}
