//
//  ApiEndpoint.swift
//  Weather App
//
//  Created by Radek Herold on 19.03.2021.
//

import Foundation

public enum ApiEndpoint: String {
    case currentWeather = "/data/2.5/weather?lat=%f&lon=%f&appid=%@"
    case forecastWeather = "/data/2.5/forecast?lat=%f&lon=%f&appid=%@"
}
