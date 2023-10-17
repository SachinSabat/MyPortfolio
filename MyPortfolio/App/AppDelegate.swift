//
//  AppDelegate.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    /// The main window of the application.
    internal var window: UIWindow?
    /// The app dependency injection container of the application.
    private let appDIContainer = AppDIContainer()

    /// The app coordinator responsible for managing app navigation.
    ///
    /// This property represents an instance of the `AppCoordinator` class, which is responsible
    /// for coordinating the navigation flow and handling high-level app logic.
    ///
    /// - Note: The app coordinator should be initialized and started during the app's launch.
    private var coordinator: Coordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Create a new UIWindow.
        window = UIWindow()
        // Apply a custom navigation theme to the app.
        AppAppearance.applyNavigationTheme()
        // Initialize and start the AppCoordinator to handle app navigation.
        if let window = window {
            coordinator = AppCoordinator(
                window: window,
                appDIContainer: appDIContainer)
            coordinator?.start()
        }
        return true
    }
}
