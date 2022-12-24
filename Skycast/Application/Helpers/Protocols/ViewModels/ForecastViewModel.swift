//
//  ForecastViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation
import Combine

protocol ForecastViewModel {
    var numberOfRows: Int { get }
    var selectedWeatherSegment: WeatherInfoSegment { get }
    var segmentsTitles: [String] { get }
    
    var segmentSelectionSubject: CurrentValueSubject<Int, Never> { get }
    var weatherInfoSelectionPublisher: AnyPublisher<WeatherInfoSegment, Never> { get }
    var weatherRecievedPublisher: AnyPublisher<Bool, Never> { get }
    var loadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorPublisher: AnyPublisher<Error, Never> { get }
    
    func updateLocation()
    func viewModelForCurrentWeather() -> CurrentWeatherViewModel
    func viewModelForCurrentTemperatureHeader() -> WeatherTemperatureViewModel
    func viewModelForWeatherDetailsCell(at indexPath: IndexPath) -> WeatherDetailsCellViewModel
    func viewModelForDailyForecastCell(at indexPath: IndexPath) -> DailyForecastCellViewModel
}
