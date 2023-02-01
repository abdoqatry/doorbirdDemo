//
//  JsonParser.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import Foundation

protocol JsonParserProtocol {
    func parse<T: Codable>(data: Data)-> AppResponse<T>
}

struct JsonParser: JsonParserProtocol {
    func parse<T: Codable>(data: Data)-> AppResponse<T> {
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return .success(model)
        } catch {
            return .error(.canNotDecode)
        }
    }
}
