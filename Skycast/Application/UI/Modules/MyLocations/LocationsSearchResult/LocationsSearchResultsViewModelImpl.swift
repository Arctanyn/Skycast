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
    
    var clearResultsSubject: PassthroughSubject<Void, Never> = PassthroughSubject()
    
    private var updateResultsSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
        
    private var cities = [City]()
    
    //MARK: - Initialization
    
    init() {
        setBindings()
    }
    
    //MARK: - Methods
    
    func titleForLocation(at indexPath: IndexPath) -> String {
        cities[indexPath.row].name ?? ""
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
    }
}
