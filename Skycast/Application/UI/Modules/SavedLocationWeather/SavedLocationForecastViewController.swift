//
//  SavedLocationForecastViewController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import UIKit
import Combine

final class SavedLocationForecastViewController: BaseViewController, ViewModelable {
    
    typealias ViewModel = SavedLocationWeatherViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            forecastView.viewModel = viewModel.viewModelForWeatherForecastView()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var forecastView = ForecastView()
    
    private lazy var closeButton: UIBarButtonItem = UIBarButtonItem(
        title: "Close",
        style: .plain,
        target: self,
        action: #selector(closeButtonTapped)
    )
    
    //MARK: - Methods
    
    override func configureAppearance() {
        super.configureAppearance()
        setupNavigationBar()
    }
    
    override func setupViews() {
        view.addSubview(forecastView, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            forecastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            forecastView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            forecastView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Actions

@objc private extension SavedLocationForecastViewController {
    func closeButtonTapped() {
        viewModel.closePage()
    }
}

//MARK: - Private methods

private extension SavedLocationForecastViewController {
    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = closeButton
        navigationController?.navigationBar.tintColor = .label
    }
}
