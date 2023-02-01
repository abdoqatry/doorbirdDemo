//
//  HomeConfiger.swift
//  doorbirdDemo
//
//  Created by Admin on 29/01/2023.
//

import UIKit


enum HoomConfiguratorType {
    case home
}

enum FoodConfigurator {
    
    static func getViewController(with type: HoomConfiguratorType) -> UIViewController {
        switch type {
            
        case .home:
            return confighomeViewController()
        }
    }
    
    private static func confighomeViewController() -> UIViewController {
        let network = Network.shared
        let repository = HomeRepository(network: network)
        let view = HomeVC()
        let presenter = homePresenter(repository, view: view)
        view.presenter = presenter
        return view
    }
}
