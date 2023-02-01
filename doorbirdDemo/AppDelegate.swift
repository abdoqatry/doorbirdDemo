//
//  AppDelegate.swift
//  doorbirdDemo
//
//  Created by Admin on 26/01/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
            let mainViewController = FoodConfigurator.getViewController(with: .home)
            
            window?.rootViewController = mainViewController
            window?.makeKeyAndVisible()
                }
//        let vc = Bundle.main.loadNibNamed("AudioVC", owner: nil, options: nil)![0] as! AudioVC
//        let home = UINavigationController(rootViewController: vc)
//        window?.rootViewController = vc
        return true
    }

   



}

