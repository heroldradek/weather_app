//
//  BaseViewModel.swift
//  Weather App
//
//  Created by Radek Herold on 19.03.2021.
//

import Foundation

protocol BaseViewModel {
    var service: WeatherService { get }
}
