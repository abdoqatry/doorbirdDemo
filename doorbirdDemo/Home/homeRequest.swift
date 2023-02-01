//
//  homeRequest.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import Foundation
enum HomeRequest: BaseURLRequest {
    
    case home
    
    var method: HTTPMethod {
        switch self {
        case.home:
            return .get
        }
    }
    
    
    var path: String {
        switch self {
        case .home:
            return "info"
        }
    }
}
