//
//  WeatherModule.swift
//  Weather App
//
//  Created by Radek Herold on 20.03.2021.
//

import Foundation
import UIKit

class WeatherModule {
    
    private let service: WeatherService
    
    init(apiGateway: ApiGateway) {
        service = WeatherService(api: WeatherApi(gateway: apiGateway))
    }
    
    public func createTabbar() -> UIViewController {
        let tabBarVC = UITabBarController()
        let weatherSection = showCurrentWeatherSection()
        let forecastSection = showForecastSection()
        weatherSection.tabBarItem = UITabBarItem(
            title: "TODAY_TITLE".localize,
            image: #imageLiteral(resourceName: "today_inactive_icon"),
            selectedImage: #imageLiteral(resourceName: "today_active_icon")
        )
        forecastSection.tabBarItem = UITabBarItem(
            title: "FORECAST_TITLE".localize,
            image: #imageLiteral(resourceName: "forecast_inactive_icon"),
            selectedImage: #imageLiteral(resourceName: "forecast_active_icon")
        
        )
        tabBarVC.viewControllers = [weatherSection, forecastSection]
        return tabBarVC
    }
    
    private func showCurrentWeatherSection() -> UIViewController {
        let viewModel = CurrentWeatherViewModel(service: service)
        return NavigationViewController(rootViewController: CurrentWeatherViewController(viewModel: viewModel))
    }
    
    private func showForecastSection() -> UIViewController {
        let viewModel = ForecastWeatherViewModel(service: service)
        return NavigationViewController(rootViewController: ForecastWeatherViewController(viewModel: viewModel))
    }
    
    
}
