//
//  WeatherApi.swift
//  Weather App
//
//  Created by Radek Herold on 20.03.2021.
//

import Foundation
import RxSwift

class WeatherApi: BaseApi {
    func getCurrentWeather(with latitude: Double, longtitude: Double) -> Observable<ApiEvent<CurrentWeather>> {
        let endPoint = String(format: ApiEndpoint.currentWeather.rawValue, latitude, longtitude, Constants.apiKey)
        return request(endPoint: endPoint)
    }
    
    func getForecast(with latitude: Double, longtitude: Double) -> Observable<ApiEvent<ForecastEntity>> {
        let endPoint = String(format: ApiEndpoint.forecastWeather.rawValue, latitude, longtitude, Constants.apiKey)
        return request(endPoint: endPoint)
    }
}
