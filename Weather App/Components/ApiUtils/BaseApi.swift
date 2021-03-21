//
//  BaseApi.swift
//  Weather App
//
//  Created by Radek Herold on 20.03.2021.
//

import Alamofire
import RxSwift
import RxSwiftExt

enum ApiEvent<T> {
    case loading
    case loaded(T)
    case error(Error)
    
    var isLoaded: Bool {
        if case .loaded = self {
            return true
        }
        return false
    }
    
    var isLoading: Bool {
        if case .loading = self {
            return true
        } else {
            return false
        }
    }
    
    var isError: Bool {
        if case .error = self {
            return true
        } else {
            return false
        }
    }
    
    var loaded: T? {
        guard case .loaded(let value) = self else { return nil }
        return value
    }
    
    var error: Error? {
        guard case .error(let value) = self else { return nil }
        return value
    }
}

extension ApiEvent: Equatable where T: Equatable {
    static func == (lhs: ApiEvent<T>, rhs: ApiEvent<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading), (.error, .error):
            return true
        case (.loaded(let l), .loaded(let r)):
            return l == r
        default:
            return false
        }
    }
}

class BaseApi {
    private let gateway: ApiGateway
    
    init(gateway: ApiGateway) {
        self.gateway = gateway
    }
    
    public init(baseUrl: String) {
        self.gateway = ApiGateway(baseUrl: baseUrl)
    }
    
    private func getEndpointUrl(endPoint: String) -> String {
        return gateway.getEndpointURL(endPoint: endPoint)
    }
    
    public func request<T:Decodable>(endPoint: String, method: Method = .get, params: [String: Any]? = nil, headers: HTTPHeaders? = nil) -> Observable<ApiEvent<T>> {
        return ApiProvider.instance.request(endPoint: getEndpointUrl(endPoint: endPoint), method: method, params: params, headers: headers)
    }
}
