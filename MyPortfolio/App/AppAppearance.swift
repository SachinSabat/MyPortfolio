//
//  AppAppearance.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

final class AppAppearance {
    /// Applies a custom navigation bar appearance theme to the app.
    ///
    /// This function configures the appearance of the navigation bar in the app by setting the title text attributes
    /// to white color and the background color to system purple.
    ///
    /// - Important: This function should be called early in the app's lifecycle, preferably during app setup.
    static func applyNavigationTheme() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        navigationBarAppearance.backgroundColor = UIColor.systemPurple
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
