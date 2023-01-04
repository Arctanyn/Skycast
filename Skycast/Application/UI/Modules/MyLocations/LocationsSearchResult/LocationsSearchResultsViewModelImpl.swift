//
//  LocationsSearchResultsViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import Foundation
import Combine

final class LocationsSearchResultsViewModelImpl: LocationsSearchResultsViewModel {
    
    //MARK: Properties

    var numberOfResults: Int {
        cities.count
    }
    
    var updateResultsPublisher: AnyPublisher<Void, Never> {
        updateResultsSubject.eraseToAnyPublisher()
    }
    
    var locationSelectionSubject: PassthroughSubject<IndexPath, Never> = PassthroughSubject()
    
    var clearResultsSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    private var updateResultsSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
        
    private var cities = [City]()
    private let coordinator: MyLocationsCoordinator
    
    //MARK: - Initialization
    
    init(coordinator: MyLocationsCoordinator) {
        self.coordinator = coordinator
        setBindings()
    }
    
    //MARK: - Methods
    
    func titleForLocation(at indexPath: IndexPath) -> String {
        let city = cities[indexPath.row]
        
        guard
            let cityName = city.name,
            let regionName = city.region,
            let countryName = city.country
        else { return "" }
        
        if cityName == regionName {
            return "\(cityName), \(countryName)"
        } else {
            return "\(cityName), \(regionName), \(countryName)"
        }
    }
    
    func updateResults(with cities: [City]) {
        self.cities = cities
        updateResultsSubject.send()
    }
}

//MARK: - Private methods

private extension LocationsSearchResultsViewModelImpl {
    func setBindings() {
        clearResultsSubject
            .sink { [weak self] in
                self?.updateResults(with: [])
            }
            .store(in: &cancellables)
        
        locationSelectionSubject
            .compactMap { [weak self] indexPath in
                self?.cities[indexPath.row]
            }
            .sink { [weak self] city in
                self?.coordinator.showForecastForSearchResult(with: city)
            }
            .store(in: &cancellables)
        
    }
}
