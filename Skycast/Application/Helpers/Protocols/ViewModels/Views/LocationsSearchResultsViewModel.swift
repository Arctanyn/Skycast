//
//  LocationsSearchResultsViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 30.12.2022.
//

import Foundation
import Combine

protocol LocationsSearchResultsViewModel: AnyObject {
    var numberOfResults: Int { get }
    var updateResultsPublisher: AnyPublisher<Void, Never> { get }
    var locationSelectionSubject: PassthroughSubject<IndexPath, Never> { get }
    var clearResultsSubject: PassthroughSubject<Void, Never> { get }
    func titleForLocation(at indexPath: IndexPath) -> String
    func updateResults(with cities: [City])
}
