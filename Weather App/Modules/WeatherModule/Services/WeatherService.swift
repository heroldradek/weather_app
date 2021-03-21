//
//  WeatherService.swift
//  Weather App
//
//  Created by Radek Herold on 20.03.2021.
//

import RxSwift
import CoreLocation

class WeatherService {
    private let api: WeatherApi
    
    init(api: WeatherApi) {
        self.api = api
    }
    
    func getCurrentWeather(with location: CLLocation) -> Observable<ApiEvent<CurrentWeather>>{
        return api.getCurrentWeather(
            with: location.coordinate.latitude.magnitude,
            longtitude: location.coordinate.longitude.magnitude
        )
    }
    
    func getForecast(with location: CLLocation) -> Observable<ApiEvent<ForecastEntity>> {
        return api.getForecast(
            with: location.coordinate.latitude.magnitude,
            longtitude: location.coordinate.longitude.magnitude
        )
    }
}
