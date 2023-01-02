//
//  HourlyForecastCollectionViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import UIKit

final class HourlyForecastCollectionViewCell: BaseCollectionViewCell, ViewModelable {
    
    typealias ViewModel = HourlyForecastCollectionViewCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            weatherTableView.reloadData()
        }
    }
    
    //MARK: - Views
    
    private lazy var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(HourlyForecastTableViewCell.self, forCellReuseIdentifier: HourlyForecastTableViewCell.identifier)
        return tableView
    }()
    
    //MARK: - Methods
    
    override func configureAppearance() {
        backgroundColor = Resources.Colors.secondaryBackground
    }
    
    override func setupViews() {
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        contentView.addSubview(weatherTableView, useAutoLayout: true)
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

//MARK: - UITableViewDataSource & UITableViewDelegate

extension HourlyForecastCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel != nil ? viewModel.numberOfRows : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HourlyForecastTableViewCell.identifier, for: indexPath) as! HourlyForecastTableViewCell
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
}
