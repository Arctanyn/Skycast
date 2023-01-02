//
//  LocationsSearchResultsController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import UIKit
import Combine

final class LocationsSearchResultsController: BaseViewController, ViewModelable {
    
    typealias ViewModel = LocationsSearchResultsViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            viewModel.updateResultsPublisher
                .sink { [weak self] in
                    self?.locationsTableView.reloadData()
                }
                .store(in: &cancellables)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Views
    
    private lazy var locationsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        return tableView
    }()
    
    //MARK: - View Controller Lyfecycle
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.clearResultsSubject.send()
    }
    
    //MARK: - Methods
    
    override func setupViews() {
        locationsTableView.dataSource = self
        locationsTableView.delegate = self
        view.addSubview(locationsTableView, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            locationsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            locationsTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationsTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - UITableViewDataSource & UITableViewDelegate

extension LocationsSearchResultsController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel != nil ? viewModel.numberOfResults : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = viewModel.titleForLocation(at: indexPath)
        cell.contentConfiguration = configuration
        
        cell.backgroundColor = Resources.Colors.background
        return cell
    }
}
