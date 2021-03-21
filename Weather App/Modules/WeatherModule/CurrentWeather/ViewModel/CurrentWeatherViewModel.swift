//
//  CurrentWeatherViewModel.swift
//  Weather App
//
//  Created by Radek Herold on 19.03.2021.
//

import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class CurrentWeatherViewModel : BaseViewModel {
    
    private let disposeBag = DisposeBag()
    
    let service: WeatherService
    
    //Inputs
    let didLoad = PublishSubject<Void>()
    let location = PublishSubject<CLLocation?>()
    let authorizationState = PublishSubject<CLAuthorizationEvent>()
    let tryAgainButtonPressed = PublishSubject<Void>()
    let settingsButtonPressed = PublishSubject<Void>()
    let shareButtonPressed = PublishSubject<Void>()
    
    //Outputs
    let hud: Driver<HudStatus>
    let hide: Driver<Error>
    let show: Driver<Bool>
    let disableTracking: Driver<Void>
    let tryAgain: Driver<Void>
    let authDenied: Driver<Void>
    let title: Driver<String>
    let conditionsText: Driver<String>
    let icon: Driver<UIImage?>
    let city: Driver<String>
    let humidity: Driver<String>
    let precipitation: Driver<String>
    let pressure: Driver<String>
    let windSpeed: Driver<String>
    let windDirection: Driver<String>
    let showSettings: Driver<Void>
    let showAllert: Driver<Void>
    let share: Driver<String>
    
    init(service: WeatherService) {
        self.service = service
        
        let request = location.unwrap()
            .flatMapLatest(service.getCurrentWeather)
            .share()
        
        let data = request.data()
        let error = request.errors()
        
        hide = error
            .asDriver(onErrorDriveWith: .empty())
        
        show = data.mapTo(false)
            .asDriver(onErrorDriveWith: .empty())

        disableTracking = Observable
            .merge(data.toVoid(), error.toVoid())
            .asDriver(onErrorDriveWith: .empty())
        
        let authorized = authorizationState
            .filter { $0.1 == .authorizedAlways || $0.1 == .authorizedWhenInUse }
            .toVoid()
        
        let deniedAuthorization = authorizationState
            .filter { $0.1 == .denied }
            .toVoid()
        
        tryAgain = Observable.merge(tryAgainButtonPressed, authorized)
            .asDriver(onErrorDriveWith: .empty())
         
        showAllert = deniedAuthorization
            .asDriver(onErrorDriveWith: .empty())
        
        showSettings = settingsButtonPressed
            .asDriver(onErrorDriveWith: .empty())
        
        authDenied = deniedAuthorization
            .asDriver(onErrorDriveWith: .empty())
        
        share = shareButtonPressed
            .withLatestFrom(data)
            .map { String(
                format: "SHARE_MESSAGE".localize,
                $0.fullNameLocation,
                $0.main.temperatureInCelsius,
                $0.weather.first?.description.capitalized ?? "")}
            .asDriver(onErrorDriveWith: .empty())
        
        precipitation = didLoad
            .mapTo("n/a")
            .asDriver(onErrorDriveWith: .empty())
        
        windSpeed = data
            .map { $0.wind.windSpeed }
            .asDriver(onErrorDriveWith: .empty())
        
        windDirection = data
            .map { $0.wind.direction }
            .asDriver(onErrorDriveWith: .empty())

        pressure = data
            .map { $0.main.pascalPressure }
            .asDriver(onErrorDriveWith: .empty())

        humidity = data
            .map { $0.main.humidityPercentage }
            .asDriver(onErrorDriveWith: .empty())

        city = data
            .map { $0.fullNameLocation }
            .asDriver(onErrorDriveWith: .empty())
        
        icon = data
            .map { $0.weather.first?.truncateDescription }
            .unwrap()
            .map { UIImage(named: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        conditionsText = data
            .map { "\($0.main.temperatureInCelsius) | \($0.weather.first?.main.capitalized ?? "")" }
            .asDriver(onErrorDriveWith: .empty())
        
        title = didLoad
            .mapTo("TODAY_TITLE".localize)
            .asDriver(onErrorDriveWith: .empty())
        
        hud = HudStatus.merge(request.hud())
    }
    
}
