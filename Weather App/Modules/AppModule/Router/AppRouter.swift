//
//  AppRouter.swift
//  Weather App
//
//  Created by Radek Herold on 21.03.2021.
//

import UIKit
import Foundation

class AppRouter {
    
    private let apiGateway = ApiGateway(baseUrl: Constants.baseURL)
    
    init(){}
    
    private func getWeatherModule() -> UIViewController {
        let module = WeatherModule(apiGateway: apiGateway)
        return module.createTabbar()
    }
    
    public func initialize() -> UIViewController {
       return getWeatherModule()
    }
}
