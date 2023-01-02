//
//  ForecastViewViewModel.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import Foundation
import Combine

protocol ForecastViewViewModel {
    var numberOfItems: Int { get }
    var segmentsTitles: [String] { get }
    var segmentSelectionSubject: CurrentValueSubject<Int, Never> { get }
    var weatherInfoSelectionPublisher: AnyPublisher<WeatherInfoSegment, Never> { get }
    var weatherUpdatesPublisher: AnyPublisher<Void, Never> { get }
    
    func weatherSegmentSelected(at index: Int)
    func viewModelForCurrentWeather() -> CurrentWeatherViewModel
    func viewModelForWeatherDetailsCell() -> WeatherDetailsCollectionViewCellViewModel
    func viewModelForHourlyForecastCell() -> HourlyForecastCollectionViewCellViewModel
    func viewModelForDailyForecastCell() -> DailyForecastCollectionViewCellViewModel
    func weatherSegmentForCell(at indexPath: IndexPath) -> WeatherInfoSegment
}
