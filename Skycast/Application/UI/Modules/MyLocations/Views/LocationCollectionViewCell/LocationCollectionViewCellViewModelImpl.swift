//
//  LocationCollectionViewCellViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 04.01.2023.
//

import Foundation
import Combine

final class LocationCollectionViewCellViewModelImpl: LocationCollectionViewCellViewModel {
    
    //MARK: Properties
    
    @Published private var city: City
    @Published private var weather: Weather?
    @Published private var temperatureUnits: TemperatureUnits

    var locationNamePublisher: AnyPublisher<String, Never> {
        $city
            .compactMap { $0.name }
            .eraseToAnyPublisher()
    }
    
    var temperaturePublisher: AnyPublisher<Temperature, Never> {
        $weather.combineLatest($temperatureUnits)
            .compactMap { weather, units in
                guard let currentWeather = weather?.current else { return nil }
                return (currentWeather, units)
            }
            .flatMap { currentWeather, units in
                Just(currentWeather).mapToTemperature(in: units)
            }
            .eraseToAnyPublisher()
    }
    
    var conditionPublisher: AnyPublisher<String, Never> {
        $weather
            .compactMap { $0?.current?.condition?.text }
            .eraseToAnyPublisher()
    }
    
    var weatherIconPublisher: AnyPublisher<(code: Int, dayPeriod: DayPeriod), Never> {
        weatherCodePublisher.combineLatest(dayPeriodPublisher)
            .map { ($0, $1) }
            .eraseToAnyPublisher()
    }
    
    var lowTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $weather
            .compactMap { $0?.forecast?.forecastday?.first?.day }
            .mapToTemperature(type: .low, in: temperatureUnits)
            .eraseToAnyPublisher()
    }
    
    var highTemperaturePublisher: AnyPublisher<Temperature, Never> {
        $weather
            .compactMap { $0?.forecast?.forecastday?.first?.day }
            .mapToTemperature(type: .high, in: temperatureUnits)
            .eraseToAnyPublisher()
    }
    
    private var weatherCodePublisher: AnyPublisher<Int, Never> {
        $weather
            .compactMap { $0?.current?.condition?.code }
            .eraseToAnyPublisher()
    }
    
    private var dayPeriodPublisher: AnyPublisher<DayPeriod, Never> {
        $weather
            .compactMap { $0?.current?.isDay }
            .compactMap { DayPeriod(rawValue: $0) }
            .eraseToAnyPublisher()
        
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private var apiService: WeatherAPIService
    
    
    //MARK: - Initialization
    
    init(city: City, apiService: WeatherAPIService, temperatureUnits: TemperatureUnits) {
        self.city = city
        self.apiService = apiService
        self.temperatureUnits = temperatureUnits
    }
    
    //MARK: - Methods
    
    func getWeather() {
        guard let coordinate = city.coordinate else { return }
        
        do {
            let forecastPublisher = try apiService.getForecast(coordinate: coordinate)
            
            forecastPublisher
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    if case .failure(let error) = completion {
                        print(error)
                    }
                } receiveValue: { [weak self] weather in
                    self?.weather = weather
                }
                .store(in: &cancellables)
        } catch {
            print(error.localizedDescription)
        }

    }
}
