//
//  FoodRepository.swift
//  doorbirdDemo
//
//  Created by Admin on 29/01/2023.
//

import Foundation


protocol HomeRepositoryProtocol {
    func homeFoods(token:String,completion: @escaping Handler<[NotificationModel]>)
}

class HomeRepository {
    // MARK: - Properties
    private let network: NetworkProtocol
    
    // MARK: - Init
    init(network: NetworkProtocol) {
        self.network = network
    }
}

extension HomeRepository: HomeRepositoryProtocol {
    func homeFoods(token:String,completion: @escaping Handler<[NotificationModel]>) {
        network.request(url: HomeRequest.home,token:token, completionHandler: completion)
    }
}
