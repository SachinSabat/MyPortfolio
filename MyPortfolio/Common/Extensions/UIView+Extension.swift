//
//  UIView+Extension.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit.UIActivity

extension UIView {
    /// To show loader
    func showSpinner() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black.withAlphaComponent(0.8)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: ConstraintConstants.number40.rawValue).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: ConstraintConstants.number40.rawValue).isActive = true
    }

    /// To hide loader
    func hideSpinner() {
        guard let spinner = self.subviews.last as? UIActivityIndicatorView else { return }
        spinner.stopAnimating()
        spinner.removeFromSuperview()
    }
}
