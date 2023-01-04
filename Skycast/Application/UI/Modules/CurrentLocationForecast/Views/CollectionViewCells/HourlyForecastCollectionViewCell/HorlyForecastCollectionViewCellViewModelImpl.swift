//
//  HorlyForecastCollectionViewCellViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import Foundation

final class HorlyForecastCollectionViewCellViewModelImpl: HourlyForecastCollectionViewCellViewModel {
    
    //MARK: Properties
    
    var numberOfRows: Int {
        hours?.count ?? 0
    }
    
    private let hours: [Hour]?
    private let temperatureUnits: TemperatureUnits
    
    //MARK: - Initialization
    
    init(hours: [Hour]?, temperatureUnits: TemperatureUnits) {
        self.hours = hours
        self.temperatureUnits = temperatureUnits
    }
    
    func viewModelForCell(at indexPath: IndexPath) -> HourlyForecastCellViewModel {
        return HourlyForecastCellViewModelImpl(
            hour: hours?[indexPath.row],
            temperatureUnits: temperatureUnits
        )
    }
    
    
}
