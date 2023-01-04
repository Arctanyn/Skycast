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
        myLocations.count
    }
    
    @Published private var searchResults = [City]()
    @Published private var temperatureUnits: TemperatureUnits = .celsius
    
    private var myLocations: [City] = []
    
    var searchResultsUpdatingPublisher: AnyPublisher<[City], Never> {
        $searchResults.eraseToAnyPublisher()
    }
    
    var addingNewLocationPublisher: AnyPublisher<Int, Never> {
        addingNewLocationSubject.eraseToAnyPublisher()
    }
    
    private let addingNewLocationSubject = PassthroughSubject<Int, Never>()
        
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherAPIService
    private let coordinator: MyLocationsCoordinator
    
    //MARK: - Initialization
    
    init(weatherService: WeatherAPIService, coordinator: MyLocationsCoordinator) {
        self.weatherService = weatherService
        self.coordinator = coordinator
        
        NotificationCenter.default.publisher(for: .addCityToMyLocation)
            .sink { [weak self] notification in
                guard
                    let self,
                    let city = notification.object as? City,
                    !(self.myLocations.contains { $0 == city })
                else { return }
                self.myLocations.append(city)
                self.addingNewLocationSubject.send(self.numberOfLocations - 1)
            }
            .store(in: &cancellables)
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
            city: myLocations[indexPath.item],
            apiService: weatherService,
            temperatureUnits: temperatureUnits
        )
    }
}
