//
//  BaseURLRequest.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import Foundation

protocol BaseURLRequest {
    var method: HTTPMethod { get }
    var path: String { get }
    var baseUrl: String { get }
    func urlRequest() -> URLRequest
}

extension BaseURLRequest {
    var baseUrl: String {
        return DomainURL.production.path
    }
    
    func urlRequest() -> URLRequest {
        let baseURL = URL(string: baseUrl)!
        var urlRequest = URLRequest(url: baseURL.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
