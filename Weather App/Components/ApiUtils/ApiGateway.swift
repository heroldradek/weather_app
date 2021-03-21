//
//  ApiGateway.swift
//  Weather App
//
//  Created by Radek Herold on 19.03.2021.
//

import Foundation

protocol Gateway {
    func getEndpointURL(endPoint: String) -> String
}

class ApiGateway: Gateway {
    private let baseUrl: String
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
    func getEndpointURL(endPoint: String) -> String {
        return prepareUrl(endPoint: endPoint)
    }
    
    private func prepareUrl(endPoint: String) -> String {
        return "\(baseUrl)\(endPoint)"
    }
}
