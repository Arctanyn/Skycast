//
//  DailyForecastCollectionViewCell.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import UIKit

final class DailyForecastCollectionViewCell: BaseCollectionViewCell, ViewModelable {
    
    typealias ViewModel = DailyForecastCollectionViewCellViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            weatherTableView.reloadData()
        }
    }
    
    //MARK: - Views
    
    private lazy var dailyForecastHeaderView = DailyForecastHeaderView(frame: CGRect(
        origin: weatherTableView.frame.origin,
        size: CGSize(width: weatherTableView.bounds.width, height: 40)
    ))
    
    private lazy var weatherTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
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

private extension DailyForecastCollectionViewCell {
    func setupTableView() {
        contentView.addSubview(weatherTableView, useAutoLayout: true)
        weatherTableView.dataSource = self
        weatherTableView.delegate = self
        weatherTableView.tableHeaderView = dailyForecastHeaderView
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension DailyForecastCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel != nil ? viewModel.numberOfRows : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier, for: indexPath) as! DailyForecastTableViewCell
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        if indexPath.row == 0 {
            cell.changeLabelsColor(to: Resources.Colors.blue)
        }
        return cell
    }
}
