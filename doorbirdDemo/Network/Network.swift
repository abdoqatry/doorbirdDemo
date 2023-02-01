//
//  Network.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import Foundation

typealias Handler<T> = (AppResponse<T>) -> Void

protocol NetworkProtocol {
    func request <T: Codable>(url: BaseURLRequest,token:String, completionHandler: @escaping Handler<T>)
}

class Network {
    
    // MARK: - Properties
    private let responseError: ResponseErrorProtocol
    private let parser: JsonParserProtocol
    private var session: URLSession
    #if TESTING
    static var shared = Network()
    
    // MARK: - Init
    init(session: URLSession = URLSession(configuration: .default),
         responseError: ResponseErrorProtocol = NetworkResponseError(),
         parser: JsonParserProtocol = JsonParser()) {
        
        self.session = session
        self.responseError = responseError
        self.parser = parser
    }
    #else
    static let shared = Network()
    private init(session: URLSession = URLSession(configuration: .default),
                 responseError: ResponseErrorProtocol = NetworkResponseError(),
                 parser: JsonParserProtocol = JsonParser()) {
        
        self.session = session
        self.responseError = responseError
        self.parser = parser
    }
    #endif
}

extension Network: NetworkProtocol {
    
    func request <T: Codable>(url: BaseURLRequest,token:String, completionHandler: @escaping Handler<T>) {
        var request = url.urlRequest()
        request.setValue("cloud-mjpg", forHTTPHeaderField:"active")
        request.setValue("Bearer 9c84629839f50271e60bf7e4da474aec34bbf449c4b8fb2065bb9a91cda52d62", forHTTPHeaderField:"Authorization")
        session.dataTask(with: request) { [weak self] data, _, error in
            guard let self = self else { return }
            
            if let responseError = error { // Response error
                let responseError = self.responseError.filter(error: responseError)
                DispatchQueue.main.async { completionHandler(AppResponse.error(responseError))}
                
            } else if let responseData = data { // Success response
                let result: AppResponse<T> = self.parser.parse(data: responseData)
                DispatchQueue.main.async { completionHandler(result) }
            }
        }.resume()
    }
}
