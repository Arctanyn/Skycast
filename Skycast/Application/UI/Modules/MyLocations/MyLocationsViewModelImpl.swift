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
    
    @Published private var searchResults = [City]()
    
    var searchResultsUpdatingPublisher: AnyPublisher<[City], Never> {
        $searchResults.eraseToAnyPublisher()
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let weatherService: WeatherAPIService
    
    //MARK: - Initialization
    
    init(weatherService: WeatherAPIService) {
        self.weatherService = weatherService
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
    
    func viewModelForLocationsSearchResultController() -> LocationsSearchResultsViewModel {
        return LocationsSearchResultsViewModelImpl()
    }
}
