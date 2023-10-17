//
//  UIViewController+Extension.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

/// Just to keep it DRY
///
internal protocol PresentAlert {
    func showAlertWith(message: String, performAction: @escaping () -> Void)
}

/// By default method declaration which will be avilable only to the VC confirming the protocol
///  won't be available to all VC
extension PresentAlert where Self: UIViewController {
    func showAlertWith(message: String, performAction: @escaping () -> Void) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: Strings.alert.rawValue,
                                          message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Strings.retry.rawValue,
                                          style: .destructive,
                                          handler: {_ in
                performAction()
            }))
            alert.view.accessibilityIdentifier = AccessibiltyIdentifier.HomeAlertMessage.rawValue
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
