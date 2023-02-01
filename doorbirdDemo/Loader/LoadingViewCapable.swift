//
//  LoadingViewCapable.swift
//  doorbirdDemo
//
//  Created by Admin on 29/01/2023.
//

import UIKit

protocol LoadingViewCapable: AnyObject {
    func showLoader()
    func hideLoader()
}

extension LoadingViewCapable where Self: UIViewController {
    func showLoader() {
        let loader = LoadingView.shared
        view.addSubview(loader)
        view.bringSubviewToFront(loader)
        
        loader.heightSize(size: 80)
        loader.widthSize(size: 80)
        loader.centerX(anchor: view.centerXAnchor)
        loader.centerY(anchor: view.centerYAnchor)
        loader.activityIndicator.startAnimating()
    }
    func hideLoader() {
        let loader = LoadingView.shared
        loader.removeFromSuperview()
    }
}
