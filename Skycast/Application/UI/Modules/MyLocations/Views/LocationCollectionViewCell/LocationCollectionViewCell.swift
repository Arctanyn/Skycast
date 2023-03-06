//
//  LocationCollectionViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import UIKit
import Combine

class LocationCollectionViewCell: BaseCollectionViewCell, ViewModelable {
    
    typealias ViewModel = LocationCollectionViewCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            setBindings()
            viewModel.getWeather()
        }
    }
    
    var isAllowsSelection = false
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 10,
        alignment: .leading,
        arrangedSubviews: [
            locationLabel,
            mainHStack,
            conditionLabel,
            lowHighTemperatureHStack
        ]
    )
    
    private lazy var mainHStack = UIStackView(
        axis: .horizontal,
        spacing: 20,
        arrangedSubviews: [temperatureLabel, weatherIconImageView]
    )
    
    private lazy var lowHighTemperatureHStack = UIStackView(
        axis: .horizontal,
        spacing: 10,
        arrangedSubviews: [lowTemperatureLabel, highTemperatureLabel]
    )
    
    private lazy var locationLabel = UILabel(
        font: Resources.Fonts.system(size: 19, weight: .bold)
    )
    
    private lazy var temperatureLabel = UILabel(
        font: Resources.Fonts.system(size: 25, weight: .bold)
    )
    
    private lazy var weatherIconImageView = UIImageView(contentMode: .scaleAspectFit)
    
    private lazy var conditionLabel = UILabel(
        textColor: .lightText,
        font: Resources.Fonts.system(size: 14, weight: .medium)
    )
    
    private lazy var lowTemperatureLabel = UILabel(
        textColor: Resources.Colors.darkText,
        font: Resources.Fonts.system(size: 14),
        textAlignment: .left
    )
    
    private lazy var highTemperatureLabel = UILabel(
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
        contentView.addSubview(locationLabel, useAutoLayout: true)
        contentView.addSubview(mainVStack, useAutoLayout: true)
    }
    
    override func constraintViews() {
        lowTemperatureLabel.setContentHuggingPriority(.required, for: .horizontal)
        NSLayoutConstraint.activate([
//            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 35),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
//
//            mainVStack.topAnchor.constraint(greaterThanOrEqualTo: locationLabel.bottomAnchor, constant: 20),
//            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
//            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
//            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

//MARK: - Private methods

private extension LocationCollectionViewCell {
    func setBindings() {
        viewModel.weatherRecievedPublisher
            .sink { [weak self] isRecieved in
                self?.isAllowsSelection = isRecieved
                self?.updateUI(isWeatherRecieved: isRecieved)
            }
            .store(in: &cancellables)
        
        viewModel.temperaturePublisher
            .map { $0.stringFormat }
            .assignToTextOnLabel(temperatureLabel)
            .store(in: &cancellables)
        
        viewModel.locationNamePublisher
            .assignToTextOnLabel(locationLabel)
            .store(in: &cancellables)
        
        viewModel.weatherIconPublisher
            .sink { [weak self] code, dayPeriod in
                self?.weatherIconImageView.image = Resources.Images.Weather.weatherIcon(
                    code: code,
                    dayPriod: dayPeriod
                )
            }
            .store(in: &cancellables)
        
        viewModel.lowTemperaturePublisher
            .map { $0.stringFormat }
            .sink { [weak self] in
                self?.lowTemperatureLabel.text = "L: \($0)"
            }
            .store(in: &cancellables)
        
        viewModel.highTemperaturePublisher
            .map { $0.stringFormat }
            .sink { [weak self] in
                self?.highTemperatureLabel.text = "H: \($0)"
            }
            .store(in: &cancellables)
        
        viewModel.conditionPublisher
            .assignToTextOnLabel(conditionLabel)
            .store(in: &cancellables)
    }
    
    func updateUI(isWeatherRecieved: Bool) {
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.mainVStack.alpha = isWeatherRecieved ? 1 : 0
        }
    }
    
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
