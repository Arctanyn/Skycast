//
//  WeatherDetailsCollectionViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import UIKit

final class WeatherDetailsCollectionViewCell: BaseCollectionViewCell, ViewModelable {
    
    typealias ViewModel = WeatherDetailsCollectionViewCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            lowHighTemperaturesView.viewModel = viewModel.viewModelForTemperaturesView()
            weatherTableView.reloadData()
        }
    }
    
    //MARK: - Views
    
    private lazy var lowHighTemperaturesView = LowHighWeatherTemperaturesView(frame: CGRect(
        origin: contentView.bounds.origin,
        size: CGSize(
            width: contentView.bounds.width,
            height: 120
        ))
    )
    
    private lazy var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(WeatherDetailsTableViewCell.self, forCellReuseIdentifier: WeatherDetailsTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Methods
    
    override func configureAppearance() {
        backgroundColor = Resources.Colors.secondaryBackground
    }
    
    override func setupViews() {
        setupTableView()
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            weatherTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            weatherTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            weatherTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            weatherTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}

//MARK: - Private methods

private extension WeatherDetailsCollectionViewCell {
    func setupTableView() {
        contentView.addSubview(weatherTableView, useAutoLayout: true)
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.tableHeaderView = lowHighTemperaturesView
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension WeatherDetailsCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel != nil ? viewModel.numberOfRows : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailsTableViewCell.identifier, for: indexPath) as! WeatherDetailsTableViewCell
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}
