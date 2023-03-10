//
//  CurrentLocationForecastViewModelImpl.swift
//  Skycast
//
//  Created by Малиль Дугулюбгов on 17.12.2022.
//

import Foundation
import CoreLocation
import Combine

final class CurrentLocationForecastViewModelImpl: CurrentLocationForecastViewModel {

    //MARK: Properties
    
    @Published private var isRecievedWeather = false
    @Published private var isLoading = true
    
    var weatherRecievedPublisher: AnyPublisher<Bool, Never> {
        $isRecievedWeather.eraseToAnyPublisher()
    }
    
    var loadingPublisher: AnyPublisher<Bool, Never> {
        $isLoading.eraseToAnyPublisher()
    }
    
    var errorPublisher: AnyPublisher<Error, Never> {
        errorSubject.eraseToAnyPublisher()
    }
        
    private let errorSubject: PassthroughSubject<Error, Never> = PassthroughSubject()
    
    private var cancellables = Set<AnyCancellable>()
    
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
        isRecievedWeather = false
        locationManager.updateLocation()
    }
    
    func viewModelForWeatherForecastView() -> ForecastViewViewModelImpl {
        return ForecastViewViewModelImpl(weather: weather)
    }
}

//MARK: - Private methods

private extension CurrentLocationForecastViewModelImpl {
    func setBindings() {
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
        
        NotificationCenter.default.publisher(for: .updateAfterBackground)
            .sink { [weak self] _ in
                self?.updateLocation()
            }
            .store(in: &cancellables)
    }
    
    func requestWeather(for location: CLLocation) {
        do {
            let weatherPublisher = try weatherService.getForecast(for: location.coordinate)
            
            weatherPublisher
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
                        self?.isRecievedWeather = false
                        self?.errorSubject.send(error)
                    }
                    self?.isLoading = false
                } receiveValue: { [weak self] weather in
                    self?.weather = weather
                    self?.isRecievedWeather = true
                }
                .store(in: &cancellables)
        } catch {
            errorSubject.send(error)
        }
    }
}
