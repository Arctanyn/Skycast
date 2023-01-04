//
//  LocationForecastViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 02.01.2023.
//

import Foundation
import Combine

final class LocationForecastViewModelImpl: LocationForecastViewModel {
    
    @Published private var isLoading = true
    @Published private var isResieved = false
    
    var weatherRecievedPublisher: AnyPublisher<Bool, Never> {
        $isResieved.eraseToAnyPublisher()
    }
    
    private let weatherRecievedSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    private let weatherService: WeatherAPIService
    private let city: City
    private var weather: Weather?
    private let coordinator: LocationForecastCoordinator
    
    init(city: City, weatherService: WeatherAPIService, coodinator: LocationForecastCoordinator) {
        self.city = city
        self.weatherService = weatherService
        self.coordinator = coodinator
    }
    
    func viewModelForWeatherForecastView() -> ForecastViewViewModel {
        return ForecastViewViewModelImpl(weather: weather)
    }
    
    func getWeatherForecast() {
        guard let coordinate = city.coordinate else { return }
        isLoading = true
        getForecastForLocation(with: coordinate)
    }
    
    func addCityToMyLocations() {
        NotificationCenter.default.post(name: .addCityToMyLocation, object: city)
        dismissPage()
    }
    
    func moduleWillDisappear() {
        coordinator.finishCurrentFlow()
    }
    
    func dismissPage() {
        coordinator.dismissModule()
    }
}

//MARK: - Private methods

private extension LocationForecastViewModelImpl {
    func getForecastForLocation(with coordinate: Coordinate) {
        do {
            let weatherForecast = try weatherService.getForecast(coordinate: coordinate)
            
            weatherForecast
                .sink { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.isResieved = false
                        print(error)
                    }
                    self?.isLoading = false
                } receiveValue: { [weak self] weather in
                    self?.weather = weather
                    self?.isLoading = false
                    self?.isResieved = true
                }
                .store(in: &cancellables)

        } catch {
            print(error.localizedDescription)
        }
    }
}
