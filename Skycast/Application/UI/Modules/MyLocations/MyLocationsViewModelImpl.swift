//
//  MyLocationsViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import Foundation
import Combine

final class MyLocationsViewModelImpl: MyLocationsViewModel {

    //MARK: Properties
    
    var numberOfLocations: Int {
        locations.count
    }
    
    @Published private var searchResults = [City]()
    @Published private var temperatureUnits: TemperatureUnits = .celsius
    @Published private var locations = UserDefaults.standard.fetchCities() ?? []
    
    var searchResultsUpdatingPublisher: AnyPublisher<[City], Never> {
        $searchResults.eraseToAnyPublisher()
    }
    
    var addingNewLocationPublisher: AnyPublisher<Int, Never> {
        addingNewLocationSubject.eraseToAnyPublisher()
    }
    
    var removingLocationPublisher: AnyPublisher<Int, Never> {
        removingLocationSubject.eraseToAnyPublisher()
    }
    
    private let addingNewLocationSubject = PassthroughSubject<Int, Never>()
    private let removingLocationSubject = PassthroughSubject<Int, Never>()
        
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherAPIService
    private let coordinator: MyLocationsCoordinator
    
    //MARK: - Initialization
    
    init(weatherService: WeatherAPIService, coordinator: MyLocationsCoordinator) {
        self.weatherService = weatherService
        self.coordinator = coordinator
        setBindings()
    }
    
    //MARK: - Methods
    
    func searchCity(query: String) {
        do {
            let citiesPublisher = try weatherService.searchCity(query: query)
            
            citiesPublisher
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error.localizedDescription)
                    }
                } receiveValue: { [weak self] cities in
                    self?.searchResults = cities
                }
                .store(in: &cancellables)
        } catch {
            print(error)
        }
    }
    
    func viewModelForLocationsSearchResultsController() -> LocationsSearchResultsViewModel {
        return LocationsSearchResultsViewModelImpl(coordinator: coordinator)
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> LocationCollectionViewCellViewModel {
        return LocationCollectionViewCellViewModelImpl(
            city: locations[indexPath.item],
            apiService: weatherService,
            temperatureUnits: temperatureUnits
        )
    }
    
    func showForecastForLocation(with weather: Weather?) {
        coordinator.showForecastForCity(with: weather)
    }
    
    func removeLocation(at indexPath: IndexPath) {
        let index = indexPath.item
        locations.remove(at: index)
        removingLocationSubject.send(index)
    }
}

//MARK: - Private methods

private extension MyLocationsViewModelImpl {
    func setBindings() {
        $locations
            .sink { UserDefaults.standard.saveCities($0) }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .addCityToMyLocation)
            .sink { [weak self] notification in
                guard
                    let self,
                    let city = notification.object as? City,
                    !(self.locations.contains { $0 == city })
                else { return }
                self.locations.append(city)
                self.addingNewLocationSubject.send(self.numberOfLocations - 1)
            }
            .store(in: &cancellables)
    }
}
