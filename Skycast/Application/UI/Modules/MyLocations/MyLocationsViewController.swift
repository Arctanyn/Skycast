//
//  MyLocationsViewController.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 29.12.2022.
//

import UIKit
import Combine

class MyLocationsViewController: BaseViewController, ViewModelable {
    
    typealias ViewModel = MyLocationsViewModel
    
    //MARK: Properties
    
    var viewModel: ViewModel! {
        didSet {
            setupSearchResultsController()
            setBindings()
            locationsCollectionView.reloadData()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()

    //MARK: - Views
    
    private lazy var locationsSearchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: LocationsSearchResultsController())
        searchController.searchBar.tintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        return searchController
    }()
    
    private lazy var locationsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCompositionalLayout()
        )
        collectionView.isUserInteractionEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.register(LocationCollectionViewCell.self, forCellWithReuseIdentifier: LocationCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - View Controller Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocalBindings()
        addKeyboardHideTapGesture()
    }
    
    //MARK: - Methods
    
    override func configureAppearance() {
        super.configureAppearance()
        setupNavigationBar()
    }
    
    override func setupViews() {
        locationsCollectionView.dataSource = self
        locationsCollectionView.delegate = self
        view.addSubview(locationsCollectionView, useAutoLayout: true)
    }
    
    override func constraintViews() {
        NSLayoutConstraint.activate([
            locationsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            locationsCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            locationsCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            locationsCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

//MARK: - Actions

@objc private extension MyLocationsViewController {
    func dismissKeyboard() {
        locationsSearchController.searchBar.searchTextField.resignFirstResponder()
    }
}

//MARK: - Private methods

private extension MyLocationsViewController {
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1)
            )
        )
        item.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 8)
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalWidth(0.5)
            ),
            subitems: [item]
        )
        group.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func addKeyboardHideTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func setupNavigationBar() {
        changeNavigationTitle(to: Resources.Strings.TabBar.myLocations)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = locationsSearchController
    }
    
    func setBindings() {
        viewModel.searchResultsUpdatingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] cities in
                guard
                    let locationSearchResultsController = self?.locationsSearchController.searchResultsController as? LocationsSearchResultsController,
                    let rearchResultsViewModel = locationSearchResultsController.viewModel
                else { return }
                rearchResultsViewModel.updateResults(with: cities)
            }
            .store(in: &cancellables)
        
        viewModel.addingNewLocationPublisher
            .sink { [weak self] index in
                self?.locationsCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            }
            .store(in: &cancellables)
        
        viewModel.removingLocationPublisher
            .sink { [weak self] index in
                self?.locationsCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
            }
            .store(in: &cancellables)
    }
    
    func setLocalBindings() {
        NotificationCenter.default.publisher(for: UISearchTextField.textDidChangeNotification, object: locationsSearchController.searchBar.searchTextField)
            .compactMap { ($0.object as? UISearchTextField)?.text }
            .compactMap { $0.isEmpty ? nil : $0 }
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.viewModel.searchCity(query: searchText)
            }
            .store(in: &cancellables)
    }
    
    func setupSearchResultsController() {
        guard let locationsSearchResultsController = locationsSearchController.searchResultsController as? LocationsSearchResultsController else { return }
        locationsSearchResultsController.viewModel = viewModel.viewModelForLocationsSearchResultsController()
    }
}


//MARK: - UICollectionViewDataSource & UICollectionViewDelegate

extension MyLocationsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel != nil ? viewModel.numberOfLocations : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCollectionViewCell.identifier, for: indexPath) as! LocationCollectionViewCell
        cell.viewModel = viewModel.viewModelForCell(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? LocationCollectionViewCell,
            cell.isWeatherRecieved
        else { return }
        viewModel.showForecastForLocation(with: cell.viewModel.locationWeather)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(actionProvider: { [weak self] _ in
            let deleteAction = UIAction(title: "Remove from my locations", image: Resources.Images.trash, attributes: .destructive) { _ in
                self?.viewModel.removeLocation(at: indexPath)
            }
            return UIMenu(children: [deleteAction])
        })
    }
}
