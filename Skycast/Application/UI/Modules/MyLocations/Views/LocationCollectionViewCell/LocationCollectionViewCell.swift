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
        }
    }
    
    var isWeatherRecieved = false
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 10,
        arrangedSubviews: [
            mainHStack,
            conditionLabel,
            lowHighTemperatureHStack
        ]
    )
    
    private lazy var mainHStack = UIStackView(
        axis: .horizontal,
        spacing: 10,
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
            locationLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            weatherIconImageView.heightAnchor.constraint(equalToConstant: 35),
            weatherIconImageView.widthAnchor.constraint(equalTo: weatherIconImageView.heightAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 10),
            mainVStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainVStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainVStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}

//MARK: - Private methods

private extension LocationCollectionViewCell {
    func setBindings() {
        viewModel.weatherRecievedPublisher
            .sink { [weak self] isRecieved in
                self?.isWeatherRecieved = isRecieved
                if !isRecieved {
                    self?.viewModel.getWeather()
                }
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
