//
//  HomeDetailCoordinator.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit
import SwiftUI

/// A protocol defining methods for dismissing the detail screen.
protocol DetailScreenDismissFlow {
    /// Dismisses the detail screen.
    func dismissDetailPage()
}

/// A coordinator responsible for managing navigation to the Home Detail screen.
final class HomeDetailCoordinator: Coordinator {
    /// The navigation controller used for presenting the Home Detail screen.
    weak var navigationController: UINavigationController?
    /// The dependencies required for the HomeScreenFlowCoordinator.
    private let dependencies: HomeScreenFlowCoordinatorDependencies
    /// The data model representing the Home Screen Data for the Home Detail screen.
    let data: HomeScreenListItemViewData
    /// A delegate for handling favorite button updates.
    private let delegate: UpdateFavouriteDelegate

    /// Initializes a HomeDetailCoordinator with the specified parameters.
    ///
    /// - Parameters:
    ///   - navigationController: The navigation controller to use for navigation.
    ///   - data: The Home Screen Data Model for the Home Detail screen.
    ///   - delegate: A delegate for handling favorite button updates.
    init(navigationController: UINavigationController,
         data: HomeScreenListItemViewData,
         delegate: UpdateFavouriteDelegate,
         dependencies: HomeScreenFlowCoordinatorDependencies)
    {
        self.navigationController = navigationController
        self.data = data
        self.delegate = delegate
        self.dependencies = dependencies
    }

    /// Starts the Home Detail screen by presenting it.
    func start() {
        let homeDetailViewController = dependencies.makeDetailScreenViewController(data: data,
                                                                                   delegate: delegate,
                                                                                   detailScreenDismissCoordinator: self)
        navigationController?.present(homeDetailViewController, animated: true, completion: nil)
    }
}

/// An extension of the `HomeDetailCoordinator` that conforms to the `DetailScreenDismissFlow` protocol.
extension HomeDetailCoordinator: DetailScreenDismissFlow {
    /// Dismisses the detail screen by calling `dismiss(animated: true)` on the navigation controller.
    func dismissDetailPage() {
        navigationController?.dismiss(animated: true)
    }
}
