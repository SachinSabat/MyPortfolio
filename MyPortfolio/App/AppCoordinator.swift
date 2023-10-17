//
//  AppCoordinator.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

/// A protocol for defining coordinators in your app's navigation flow.
protocol Coordinator {
    /// Starts the coordinator's navigation flow.
    func start()
    /// Coordinates the navigation to another coordinator.
    ///
    /// - Parameter coordinator: The coordinator to which navigation is being coordinated.
    ///
    /// This method is used to initiate the navigation to another coordinator within the app.
    /// It typically involves calling the `start()` method of the provided coordinator.
    ///
    /// - Example:
    ///   ```
    ///   let childCoordinator = ChildCoordinator()
    ///   parentCoordinator.coordinate(to: childCoordinator)
    ///   ```
    func coordinate(to coordinator: Coordinator)
}

extension Coordinator {
    /// This default implementation of the `coordinate(to:)` method starts the provided
    /// coordinator's navigation flow by calling its `start()` method.
    ///
    func coordinate(to coordinator: Coordinator) {
        coordinator.start()
    }
}

final class AppCoordinator: Coordinator {
    /// The main window of the application and initialise it
    private let window: UIWindow
    /// The app dependency injection container of the application.
    private let appDIContainer: AppDIContainerProtocol

    init(window: UIWindow,
         appDIContainer: AppDIContainerProtocol
    ) {
        self.window = window
        self.appDIContainer = appDIContainer
    }

    /// Starts the app coordinator's navigation flow.
    ///
    /// This method initializes the app's navigation stack, sets the root view controller, makes the window key and visible,
    /// and starts the HomeScreenCoordinator to handle the initial screen.
    ///
    /// - Important: This method should be called during the app's launch, typically from the `application(_:didFinishLaunchingWithOptions:)` method.
    func start() {
        // Create a navigation controller to manage the app's navigation stack.
        let navigationController = UINavigationController()
        // Set the root view controller of the main window to the navigation controller.
        window.rootViewController = navigationController
        // Make the app's window key and visible.
        window.makeKeyAndVisible()
        // Get home screen container
        let homeScreenDIContainer = appDIContainer.makeHomeScreenDIContainer()
        // Initialize the HomeScreenCoordinator to handle the initial screen.
        let homeScreenCoordinator = homeScreenDIContainer.makeHomeScreenCoordinator(navigationController: navigationController)
        // Coordinate navigation to the HomeScreenCoordinator.
        coordinate(to: homeScreenCoordinator)
    }
}
