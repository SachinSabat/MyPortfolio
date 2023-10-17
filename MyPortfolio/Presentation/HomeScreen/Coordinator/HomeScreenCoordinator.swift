//
//  HomeScreenCoordinator.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

/// A protocol defining the flow for coordinating to the detail screen.
protocol HomeDetailScreenFlow {
    /// Coordinates to the detail screen with specified data and delegate.
    ///
    /// - Parameters:
    ///   - data: The data model to be passed to the detail screen.
    ///   - delegate: The delegate responsible for updating favorites.
    func coordinateToDetailScreen(data: HomeScreenListItemViewData,
                                  delegate: UpdateFavouriteDelegate)
}

/// The coordinator responsible for managing the home screen flow.
final class HomeScreenCoordinator: Coordinator {
    /// The navigation controller used for navigation within the Home Screen.
    private weak var navigationController: UINavigationController?
    /// The dependencies required for the Home Screen coordinator.
    private let dependencies: HomeScreenFlowCoordinatorDependencies

    init(navigationController: UINavigationController,
         dependencies: HomeScreenFlowCoordinatorDependencies)
    {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }

    /// Starts the home screen coordinator.
    ///
    /// Initializes the home screen view controller and sets it as the root view controller
    /// of the navigation controller.
    func start() {
        let homeScreenViewController = dependencies.makeHomeScreenViewController(homeScreenDetailCoordinator: self)
        navigationController?.pushViewController(homeScreenViewController, animated: true)
    }
}

// MARK: - HomeDetailScreenFlow Conformance

extension HomeScreenCoordinator: HomeDetailScreenFlow {
    // MARK: - Flow Methods
    func coordinateToDetailScreen(
        data: HomeScreenListItemViewData,
        delegate: UpdateFavouriteDelegate)
    {
        if let navigationController = navigationController {
            let homeDetailScreenCoordinator = HomeDetailCoordinator(
                navigationController: navigationController,
                data: data,
                delegate: delegate,
                dependencies: dependencies
            )
            coordinate(to: homeDetailScreenCoordinator)
        }
    }
}
