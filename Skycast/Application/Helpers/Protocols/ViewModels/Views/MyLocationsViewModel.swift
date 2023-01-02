//
//  MyLocationsViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import Foundation
import Combine

protocol MyLocationsViewModel {
    var searchResultsUpdatingPublisher: AnyPublisher<[City], Never> { get }
    func searchCity(query: String)
    func viewModelForLocationsSearchResultsController() -> LocationsSearchResultsViewModel
}
