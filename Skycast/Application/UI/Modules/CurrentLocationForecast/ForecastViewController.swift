//
//  CurrentLocationForecastViewController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit
import Combine

final class CurrentLocationForecastViewController: BaseViewController, ViewModelable {
    
    typealias ViewModel = CurrentLocationForecastViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            setBindings()
            viewModel.updateLocation()
        }
    }
    
    private var forecastViewTopConsatraint: NSLayoutConstraint!
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var forecastView = ForecastView()
    
    private lazy var messageView: MessageViewWithAction = {
        let msgView = MessageViewWithAction()
        msgView.setupMessage(
            withTitle: "Weather is unavailable",
            messageDescription: "Could not get weather information. Check your internet connection and try again",
            actionButtonText: "Tap to retry"
        )
        msgView.addTargetToButton(self, action: #selector(messageViewActionButtonTapped), forEvent: .touchUpInside)
        return msgView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    //MARK: - Methods
    
    override func configureAppearance() {
        super.configureAppearance()

    }
    
    override func setupViews() {
        view.addSubview(messageView, useAutoLayout: true)
        messageView.isHidden = true
        
        view.addSubview(loadingIndicator, useAutoLayout: true)
        view.addSubview(forecastView, useAutoLayout: true)
    }
    
    override func constraintViews() {
        forecastViewTopConsatraint = forecastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -100)
        
        NSLayoutConstraint.activate([
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            forecastViewTopConsatraint,
            forecastView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            forecastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - Actions

@objc private extension CurrentLocationForecastViewController {
    func messageViewActionButtonTapped() {
        messageView.isHidden = true
        viewModel.updateLocation()
    }
}

//MARK: - Private methods

private extension CurrentLocationForecastViewController {
    func setBindings() {
        viewModel.weatherRecievedPublisher
            .sink { [weak self] isRecieved in
                self?.updateInterface(isRecievedWeather: isRecieved)
            }
            .store(in: &cancellables)
        
        viewModel.loadingPublisher
            .sink { [weak self] isLoading in
                isLoading ? self?.loadingIndicator.startAnimating() : self?.loadingIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        
        viewModel.errorPublisher
            .sink { [weak self] error in
                self?.showAlert(withTitle: error.localizedDescription, message: "Try again now or later", actions: [
                    UIAlertAction(title: "Try again", style: .default, handler: { _ in
                        self?.viewModel.updateLocation()
                    }),
                    UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                        self?.forecastView.alpha = 0
                        self?.messageView.isHidden = false
                    })
                ])
            }
            .store(in: &cancellables)
    }
    
    func updateInterface(isRecievedWeather: Bool) {
        if isRecievedWeather {
            forecastView.viewModel = viewModel.viewModelForWeatherForecastView()
            animateViewAttachmentWithAppearance(
                forecastView,
                topConstraint: forecastViewTopConsatraint
            )
        } else {
            forecastView.alpha = 0
        }
    }
}
