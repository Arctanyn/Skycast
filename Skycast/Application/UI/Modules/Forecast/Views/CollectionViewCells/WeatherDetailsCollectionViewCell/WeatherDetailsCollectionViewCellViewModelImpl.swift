//
//  WeatherDetailsCollectionViewCellViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 01.01.2023.
//

import Foundation

final class WeatherDetailsCollectionViewCellViewModelImpl: WeatherDetailsCollectionViewCellViewModel {
    
    //MARK: Properties
    
    var numberOfRows: Int {
        WeatherDetails.allCases.count
    }
    
    private let weather: CurrentWeather?
    private let day: Day?
    private let temperatureUnits: TemperatureUnits
    
    //MARK: - Initialization
    
    init(weather: CurrentWeather?, day: Day?, temperatureUnits: TemperatureUnits) {
        self.weather = weather
        self.day = day
        self.temperatureUnits = temperatureUnits
    }
    
    //MARK: - Methods
    
    func viewModelForCell(at indexPath: IndexPath) -> WeatherDetailsCellViewModel {
        return WeatherDetailsCellViewModelImpl(
            weather: weather,
            detailsType: WeatherDetails.allCases[indexPath.row]
        )
    }
    
    func viewModelForTemperaturesView() -> LowHighWeatherTemperaturesViewModel {
        return LowHighWeatherTemperaturesViewModelImpl(
            day: day,
            temperatureUnits: temperatureUnits
        )
    }
    
}
