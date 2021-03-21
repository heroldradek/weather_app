//
//  AppModule.swift
//  Weather App
//
//  Created by Radek Herold on 21.03.2021.
//

import Foundation
import UIKit

class AppModule {
    
    private let router = AppRouter()
    
    init() {}
    
    public func initialize() -> UIViewController {
        return router.initialize()
    }
}
