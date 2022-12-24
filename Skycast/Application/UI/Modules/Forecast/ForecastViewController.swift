//
//  ForecastViewController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 16.12.2022.
//

import UIKit
import Combine

class ForecastViewController: BaseViewController, ViewModelable {
    
    typealias ViewModel = ForecastViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            configureWeatherSegments()
            setBindings()
            viewModel.updateLocation()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var messageView: MessageViewWIthAction = {
        let msgView = MessageViewWIthAction()
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
    
    private lazy var currentWeatherView = CurrentWeatherView()
    
    private lazy var weatherInfoSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()
        segmentedControl.selectedSegmentTintColor = .systemBlue
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: UIColor.systemBlue,
            .font: Resources.Fonts.system()
        ], for: .normal)
        
        segmentedControl.setTitleTextAttributes([
            .foregroundColor: Resources.Colors.background,
            .font: Resources.Fonts.system(weight: .medium)
        ], for: .selected)
        
        segmentedControl.addTarget(self, action: #selector(weatherSegmentDidChange), for: .valueChanged)
        return segmentedControl
    }()
    
    private lazy var temperaturesView = WeatherTemperatureView(frame: CGRect(
        origin: weatherTableView.frame.origin,
        size: CGSize(
            width: weatherTableView.bounds.width,
            height: 120
        ))
    )
    
    private lazy var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Resources.Colors.secondaryBackground
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        
        tableView.register(WeatherDetailsTableViewCell.self, forCellReuseIdentifier: WeatherDetailsTableViewCell.identifier)
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    private lazy var weatherDetailsVStack = UIStackView(
        axis: .vertical,
        spacing: 20,
        arrangedSubviews: [
            weatherInfoSegmentedControl
                .padded(insets: .init(top: 0, left: 20, bottom: 0, right: 20)),
            weatherTableView
        ]
    )

    private lazy var mainVStack = UIStackView(
        axis: .vertical,
        spacing: 40,
        arrangedSubviews: [
            currentWeatherView
                .padded(insets: .init(top: 0, left: 20, bottom: 0, right: 20)),
            weatherDetailsVStack
        ]
    )
    
    //MARK: - Methods
    
    override func configureAppearance() {
        title = Resources.Strings.appName
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Resources.Colors.background
    }
    
    override func setupViews() {
        view.addSubview(messageView, useAutoLayout: true)
        messageView.isHidden = true
        
        view.addSubview(loadingIndicator, useAutoLayout: true)
        view.addSubview(mainVStack, useAutoLayout: true)
        setupTableView()
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            messageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            messageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            mainVStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainVStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainVStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainVStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

//MARK: - Actions

@objc private extension ForecastViewController {
    func weatherSegmentDidChange() {
        let seletedIndex = weatherInfoSegmentedControl.selectedSegmentIndex
        viewModel.segmentSelectionSubject.send(seletedIndex)
    }
    
    func messageViewActionButtonTapped() {
        messageView.isHidden = true
        viewModel.updateLocation()
    }
}

//MARK: - Private methods

private extension ForecastViewController {
    func setBindings() {
        viewModel.weatherInfoSelectionPublisher
            .sink { [weak self] segment in
                self?.weatherTableView.reloadData()
                self?.setupTableViewHeader(for: segment)
            }
            .store(in: &cancellables)
        
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
                        self?.messageView.isHidden = false
                    })
                ])
            }
            .store(in: &cancellables)
    }
    
    func setupTableView() {
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
    }
    
    func configureWeatherSegments() {
        viewModel.segmentsTitles.enumerated().forEach { index, segmentTitle in
            weatherInfoSegmentedControl.insertSegment(withTitle: segmentTitle, at: index, animated: false)
        }
        
        weatherInfoSegmentedControl.selectedSegmentIndex = viewModel.segmentSelectionSubject.value
    }
    
    func updateInterface(isRecievedWeather: Bool) {
        if isRecievedWeather {
            weatherSegmentDidChange()
        }
        currentWeatherView.viewModel = viewModel.viewModelForCurrentWeather()
        mainVStack.isHidden = !isRecievedWeather
        
    }
    
    func setupTableViewHeader(for segment: WeatherInfoSegment) {
        switch segment {
        case .details:
            temperaturesView.viewModel = viewModel.viewModelForCurrentTemperatureHeader()
            weatherTableView.tableHeaderView = temperaturesView
        case .hourly:
            weatherTableView.tableHeaderView = nil
        case .forecast:
            weatherTableView.tableHeaderView = DailyForecastHeaderView(
                frame: CGRect(
                    origin: weatherTableView.frame.origin,
                    size: CGSize(width: weatherTableView.bounds.width, height: 40)
                )
            )
        }
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension ForecastViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.selectedWeatherSegment {
        case .details:
            let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailsTableViewCell.identifier, for: indexPath) as! WeatherDetailsTableViewCell
            cell.viewModel = viewModel.viewModelForWeatherDetailsCell(at: indexPath)
            return cell
        case .forecast:
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as! DailyForecastTableViewCell
            cell.changeLabelsColor(to: indexPath.row == 0 ? Resources.Colors.blue : .label)
            cell.viewModel = viewModel.viewModelForDailyForecastCell(at: indexPath)
            return cell
        @unknown default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            return cell
        }
    }
    
}
