//
//  DailyForecastCollectionViewCellViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import Foundation

protocol DailyForecastCollectionViewCellViewModel {
    var numberOfRows: Int { get }
    func viewModelForCell(at indexPath: IndexPath) -> DailyForecastCellViewModel
}
