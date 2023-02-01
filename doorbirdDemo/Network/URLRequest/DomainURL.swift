//
//  DomainURL.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import Foundation

enum DomainURL {
    
    case production
    
    var path: String {
        switch self {
        case .production:
            return "https://api.doorbird.io/live/"
        }
    }
}
