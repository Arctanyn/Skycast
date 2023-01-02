//
//  ForecastViewViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 31.12.2022.
//

import Foundation
import Combine

final class ForecastViewViewModelImpl: ForecastViewViewModel {
    
    //MARK: Properties
    
    @Published private var weather: Weather?
    
    var numberOfItems: Int {
        WeatherInfoSegment.allCases.count
    }
    
    var segmentsTitles: [String] {
        WeatherInfoSegment.allCases.map { $0.title }
    }
    
    var segmentSelectionSubject: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    
    var weatherInfoSelectionPublisher: AnyPublisher<WeatherInfoSegment, Never> {
        weatherInfoChangingSubject.eraseToAnyPublisher()
    }
    
    var weatherUpdatesPublisher: AnyPublisher<Void, Never> {
        $weather
            .map { _ in }
            .eraseToAnyPublisher()
    }
    
    private let weatherInfoChangingSubject: PassthroughSubject<WeatherInfoSegment, Never> = PassthroughSubject()
    
    private let errorSubject: PassthroughSubject<Error, Never> = PassthroughSubject()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var currentWeatherSegment: WeatherInfoSegment = .details
    private let temperatureUnits: TemperatureUnits = .celsius
    private let weatherDetails = WeatherDetails.allCases
    
    //MARK: - Initialization
    
    init(weather: Weather?) {
        self.weather = weather
        setBindings()
    }
    
    //MARK: - Methods
    
    func weatherSegmentSelected(at index: Int) {
        guard let weatherSegment = WeatherInfoSegment(rawValue: index) else { return }
        currentWeatherSegment = weatherSegment
    }
    
    func viewModelForCurrentWeather() -> CurrentWeatherViewModel {
        return CurrentWeatherViewModelImpl(
            weather: weather?.current,
            location: weather?.location,
            temperatureUnits: temperatureUnits
        )
    }
    
    func viewModelForWeatherDetailsCell() -> WeatherDetailsCollectionViewCellViewModel {
        return WeatherDetailsCollectionViewCellViewModelImpl(
            weather: weather?.current,
            day: weather?.forecast?.forecastday?.first?.day,
            temperatureUnits: temperatureUnits
        )
    }
    
    func viewModelForHourlyForecastCell() -> HourlyForecastCollectionViewCellViewModel {
        return HorlyForecastCollectionViewCellViewModelImpl(
            hours: weather?.forecast?.forecastday?.first?.hour,
            temperatureUnits: temperatureUnits
        )
    }
    
    func viewModelForDailyForecastCell() -> DailyForecastCollectionViewCellViewModel {
        return DailyForecastCollectionViewCellViewModelImpl(
            forecastDays: weather?.forecast?.forecastday,
            temperatureUnits: temperatureUnits
        )
    }
    
    func weatherSegmentForCell(at indexPath: IndexPath) -> WeatherInfoSegment {
        guard let weatherSegment = WeatherInfoSegment(rawValue: indexPath.item) else {
            fatalError("The number of elements doesn't correspond to the number of segments")
        }
        return weatherSegment
    }
}

//MARK: - Private methods

private extension ForecastViewViewModelImpl {
    func setBindings() {
        segmentSelectionSubject
            .compactMap { WeatherInfoSegment(rawValue: $0) }
            .sink { [weak self] segment in
                self?.currentWeatherSegment = segment
                self?.weatherInfoChangingSubject.send(segment)
            }
            .store(in: &cancellables)
    }
}
