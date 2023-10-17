//
//  BaseProtocol.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

/// Basic View functionallies
protocol BaseViewInput: AnyObject {
    /// Show Loader
    func showActivityLoader()
    /// Hide Loader
    func hideActivityLoader()
}

/// Using default implement for conforming types of UIViewController
extension BaseViewInput where Self: UIViewController {
    
    func showActivityLoader() {
        view.showSpinner()
    }

    func hideActivityLoader() {
        view.hideSpinner()
    }
}
