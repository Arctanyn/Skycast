//
//  MyLocationsViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import Foundation
import Combine

protocol MyLocationsViewModel {
    var numberOfLocations: Int { get }
    var addingNewLocationPublisher: AnyPublisher<Int, Never> { get }
    var removingLocationPublisher: AnyPublisher<Int, Never> { get }
    var searchResultsUpdatingPublisher: AnyPublisher<[City], Never> { get }
    func searchCity(query: String)
    func viewModelForLocationsSearchResultsController() -> LocationsSearchResultsViewModel
    func viewModelForCell(at indexPath: IndexPath) -> LocationCollectionViewCellViewModel
    func showForecastForLocation(with weather: Weather?)
    func removeLocation(at indexPath: IndexPath)
}
