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
    
    var numberOfRows: Int {
        guard weather != nil else { return 0 }
        
        switch currentWeatherSegment {
        case .details:
            return weatherDeatils.count
        case .hourly:
            return 0
        case .forecast:
            return 0
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
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }
    
    @Published private var currentWeatherSegment: WeatherInfoSegment = .details
    @Published private var isRecievedWeather = false
    
    private let weatherInfoChangingSubject: PassthroughSubject<WeatherInfoSegment, Never> = PassthroughSubject()
    private let errorSubject: PassthroughSubject<Error?, Never> = PassthroughSubject()
    
    private var cancellables = Set<AnyCancellable>()
    
    private var weather: Weather?
    
    private let locationManager: UserLocationManager
    private let weatherService: WeatherAPIService
    
    private let weatherDeatils = WeatherDetails.allCases
    
    //MARK: - Initialization
    
    init(locationManager: UserLocationManager, weatherService: WeatherAPIService) {
        self.locationManager = locationManager
        self.weatherService = weatherService
        setBindings()
    }
    
    //MARK: - Methods
    
    func updateLocation() {
        locationManager.updateLocation()
    }
    
    func viewModelForCurrentWeather() -> CurrentWeatherViewModel {
        let viewModel = CurrentWeatherViewModelImpl()
        viewModel.updateWeather(weather?.current, for: weather?.location)
        return viewModel
    }
    
    func viewModelForCurrentTemperatureHeader() -> WeatherTemperatureViewModel {
        return WeatherTemperatureViewModelImpl(day: weather?.forecast?.forecastday?.first?.day)
    }
    
    func viewModelForWeatherDetailsCell(at indexPath: IndexPath) -> WeatherDetailsCellViewModel {
        let detailsType = weatherDeatils[indexPath.row]
        return WeatherDetailsCellViewModelImpl(weather: weather?.current, detailsType: detailsType)
    }
    
    //MARK: - Private methods
    
    private func setBindings() {
        segmentSelectionSubject
            .compactMap { WeatherInfoSegment(rawValue: $0) }
            .sink { [weak self] segment in
                self?.currentWeatherSegment = segment
                self?.weatherInfoChangingSubject.send(segment)
            }
            .store(in: &cancellables)
        
        locationManager.locationPublisher
            .compactMap { $0 }
            .flatMap { [weak self] location in
                guard let self else { fatalError("Invalid error: Self does not exist") }
                return self.weatherService.getWeather(route: .forecast, for: location)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorSubject.send(error)
                }
                self?.isRecievedWeather = false
            } receiveValue: { [weak self] weather in
                self?.weather = weather
                self?.isRecievedWeather = true
                self?.errorSubject.send(nil)
            }
            .store(in: &cancellables)

    }
    
    
    
}
