//
//  DailyForecastCollectionViewCellViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import Foundation

final class DailyForecastCollectionViewCellViewModelImpl: DailyForecastCollectionViewCellViewModel {
    
    //MARK: Properties
    
    var numberOfRows: Int {
        forecastDays?.count ?? 0
    }
    
    private let forecastDays: [ForecastDay]?
    private let temperatureUnits: TemperatureUnits
    
    //MARK: - Initialization
    
    init(forecastDays: [ForecastDay]?, temperatureUnits: TemperatureUnits) {
        self.forecastDays = forecastDays
        self.temperatureUnits = temperatureUnits
    }
    
    //MARK: - Methods
    
    func viewModelForCell(at indexPath: IndexPath) -> DailyForecastCellViewModel {
        return DailyForecastCellViewModelImpl(
            forecastDay: forecastDays?[indexPath.row],
            temperatureUnits: temperatureUnits
        )
    }
    
    
}
