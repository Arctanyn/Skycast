//
//  HourlyForecastCollectionViewCellViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import Foundation

protocol HourlyForecastCollectionViewCellViewModel {
    var numberOfRows: Int { get }
    func viewModelForCell(at indexPath: IndexPath) -> HourlyForecastCellViewModel
}
