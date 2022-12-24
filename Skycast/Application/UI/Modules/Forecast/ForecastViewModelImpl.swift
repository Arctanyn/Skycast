//
//  ForecastViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation
import CoreLocation
import Combine

final class ForecastViewModelImpl: ForecastViewModel {

    //MARK: Properties
    
    @Published private var currentWeatherSegment: WeatherInfoSegment = .details
    @Published private var isRecievedWeather = false
    @Published private var isLoading = true
    
    var numberOfRows: Int {
        guard weather != nil else { return 0 }
        
        switch currentWeatherSegment {
        case .details:
            return weatherDeatils.count
        case .hourly:
            return weather?.forecast?.forecastday?.first?.hour?.count ?? 0
        case .forecast:
            return weather?.forecast?.forecastday?.count ?? 0
        }
    }
    
    var selectedWeatherSegment: WeatherInfoSegment {
        return currentWeatherSegment
    }
    
    var segmentsTitles: [String] {
        WeatherInfoSegment.allCases.map { $0.title }
    }
    
    var segmentSelectionSubject: CurrentValueSubject<Int, Never> = CurrentValueSubject(0)
    
    var weatherInfoSelectionPublisher: AnyPublisher<WeatherInfoSegment, Never> {
        weatherInfoChangingSubject
            .eraseToAnyPublisher()
    }
    
    var weatherRecievedPublisher: AnyPublisher<Bool, Never> {
        $isRecievedWeather.eraseToAnyPublisher()
            
    }
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private let weatherInfoChangingSubject: PassthroughSubject<WeatherInfoSegment, Never> = PassthroughSubject()
    
    private let errorSubject: PassthroughSubject<Error, Never> = PassthroughSubject()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let temperatureUnits: TemperatureUnits = .celsius
    private let weatherDeatils = WeatherDetails.allCases
    private let locationManager: UserLocationManager
    private let weatherService: WeatherAPIService
    private var weather: Weather?
    
    
    //MARK: - Initialization
    
    init(locationManager: UserLocationManager, weatherService: WeatherAPIService) {
        self.locationManager = locationManager
        self.weatherService = weatherService
        setBindings()
    }
    
    //MARK: - Methods
    
    func updateLocation() {
        isLoading = true
        locationManager.updateLocation()
    }
    
    private func requestWeather(for location: CLLocation) {
        weatherService.getWeather(route: .forecast, for: location)
            .mapError { error in
                switch error {
                case .decodingError:
                    fatalError("Decoding error: \(error.localizedDescription)")
                default:
                    return error
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.isLoading = false
                    self?.weather = nil
                    self?.isRecievedWeather = false
                    self?.errorSubject.send(error)
                }
            } receiveValue: { [weak self] weather in
                self?.weather = weather
                self?.isLoading = false
                self?.isRecievedWeather = true
            }
            .store(in: &cancellables)
    }
    
    func viewModelForCurrentWeather() -> CurrentWeatherViewModel {
        return CurrentWeatherViewModelImpl(
            weather: weather?.current,
            location: weather?.location,
            temperatureUnits: temperatureUnits
        )
    }
    
    func viewModelForCurrentTemperatureHeader() -> WeatherTemperatureViewModel {
        let day = weather?.forecast?.forecastday?.first?.day
        return WeatherTemperatureViewModelImpl(day: day, temperatureUnits: temperatureUnits)
    }
    
    func viewModelForWeatherDetailsCell(at indexPath: IndexPath) -> WeatherDetailsCellViewModel {
        let detailsType = weatherDeatils[indexPath.row]
        return WeatherDetailsCellViewModelImpl(weather: weather?.current, detailsType: detailsType)
    }
    
    func viewModelForHourlyForecastCell(at indexPath: IndexPath) -> HourlyForecastCellViewModel {
        let hour = weather?.forecast?.forecastday?.first?.hour?[indexPath.row]
        return HourlyForecastCellViewModelImpl(hour: hour, temperatureUnits: temperatureUnits)
    }
    
    func viewModelForDailyForecastCell(at indexPath: IndexPath) -> DailyForecastCellViewModel {
        let forecastDay = weather?.forecast?.forecastday?[indexPath.row]
        return DailyForecastCellViewModelImpl(forecastDay: forecastDay, temperatureUnits: temperatureUnits)
    }

}

//MARK: - Private methods

private extension ForecastViewModelImpl {
    func setBindings() {
        segmentSelectionSubject
            .compactMap { WeatherInfoSegment(rawValue: $0) }
            .sink { [weak self] segment in
                self?.currentWeatherSegment = segment
                self?.weatherInfoChangingSubject.send(segment)
            }
            .store(in: &cancellables)
        
        locationManager.locationPublisher
            .sink { [weak self] location in
                self?.requestWeather(for: location)
            }
            .store(in: &cancellables)
        
        locationManager.errorSubject
            .sink { [weak self] error in
                self?.isLoading = false
                self?.errorSubject.send(error)
            }
            .store(in: &cancellables)
    }
}
