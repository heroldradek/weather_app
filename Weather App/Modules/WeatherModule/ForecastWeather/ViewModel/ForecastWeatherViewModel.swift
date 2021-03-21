//
//  ForecastWeatherViewModel.swift
//  Weather App
//
//  Created by Radek Herold on 19.03.2021.
//

import RxSwift
import RxCocoa
import CoreLocation
import RxCoreLocation

class ForecastWeatherViewModel: BaseViewModel {
    
    private let disposeBag = DisposeBag()
    let service: WeatherService
    
    //Inputs
    let didLoad = PublishSubject<Void>()
    let location = PublishSubject<CLLocation?>()
    let authorizationState = PublishSubject<CLAuthorizationEvent>()
    let tryAgainButtonPressed = PublishSubject<Void>()
    let settingsButtonPressed = PublishSubject<Void>()
    
    //Outputs
    let hide: Driver<Error>
    let show: Driver<Bool>
    let disableTracking: Driver<Void>
    let tryAgain: Driver<Void>
    let authDenied: Driver<Void>
    let sections: Driver<[Sections]>
    let title: Driver<String>
    let showSettings: Driver<Void>
    let showAllert: Driver<Void>
    let hud: Driver<HudStatus>
    
    init(service: WeatherService) {
        self.service = service
        
        let request = location
            .unwrap()
            .flatMapLatest(service.getForecast)
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
        
        sections = request.data()
            .map(ForecastWeatherViewModel.sections)
            .asDriver(onErrorDriveWith: .empty())

        title = didLoad
            .mapTo("FORECAST_TITLE".localize)
            .asDriver(onErrorDriveWith: .empty())
        
        hud = HudStatus.merge(request.hud())
    }
    
    private static func sections(with entity: ForecastEntity) -> [Sections] {
        var sections = [Sections]()
        let dictionary = Dictionary(grouping: entity.list, by: { $0.dateId } )
        let sortedDictionary = dictionary.sorted { $0.key < $1.key }
        sortedDictionary.forEach {
            let todayDay = Date().dayOfWeek
            let items = $0.value.map { SectionItem.weatherItem(weather: $0) }
            if todayDay == $0.key.formatDate.dayOfWeek {
                sections.append(.daySection(items: [.daySection(
                        section: ("TODAY_TITLE".localize, $0.value.first?.dt_txt ?? "")
                    )
                ]))
            } else {
                sections.append(.daySection(items: [.daySection(
                        section: ($0.key.formatDate.dayOfWeek, $0.value.first?.dt_txt ?? "")
                    )
                ]))
            }
            sections.append(.weatherItem(items: items))
        }
        return sections
    }
}
