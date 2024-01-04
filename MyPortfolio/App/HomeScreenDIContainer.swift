//
//  HomeScreenDIContainer.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
import UIKit
import SwiftUI
import NetworkManager
import DataManager

/// A protocol that defines the dependencies required for the HomeScreenFlowCoordinator.
protocol HomeScreenFlowCoordinatorDependencies  {
    /// Creates and returns a `HomeScreenViewController`.
    ///
    func makeHomeScreenViewController(homeScreenDetailCoordinator: HomeDetailScreenFlow) -> HomeScreenViewController
    
    /// Creates and returns a `HomeDetailScreenView`.
    ///
    func makeDetailScreenViewController(data: HomeScreenListItemViewData,
                                        delegate: UpdateFavouriteDelegate,
                                        detailScreenDismissCoordinator: DetailScreenDismissFlow) -> UIViewController
}

/// The Dependency Injection (DI) container for the Home Screen module.
final class HomeScreenDIContainer: HomeScreenFlowCoordinatorDependencies {

    /// A structure that holds the dependencies required by the DI container.
    struct Dependencies {
        /// The network client service protocol used for API requests.
        let apiNetworkClient: NetworkClientServiceProtocol
    }

    /// The dependencies required by the DI container.
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: - View Controller
    func makeHomeScreenViewController(homeScreenDetailCoordinator: HomeDetailScreenFlow) -> HomeScreenViewController 
    {
        let homeScreenTableViewCellHandler = HomeScreenTableViewCellHandler()
        let tableViewSectionCells: TableViewSectionProtocol = TableViewSectionContainer(tableViewHandler: [homeScreenTableViewCellHandler])
        return HomeScreenViewController(
            viewModel: makeHomeScreenViewModel(),
            homeScreenTableViewController: HomeScreenTableViewController(tableViewHandler: tableViewSectionCells),
            homeScreenDetailCoordinator: homeScreenDetailCoordinator
        )
    }

    func makeDetailScreenViewController(data: HomeScreenListItemViewData,
                                        delegate: UpdateFavouriteDelegate,
                                        detailScreenDismissCoordinator: DetailScreenDismissFlow) -> UIViewController 
    {
        let viewModel = HomeDetailScreenViewModel(favDelegate: delegate,
                                                  data: data)
        let homeDetailScreenView = HomeDetailScreenView(viewModel: viewModel,
                                                        detailScreenDismissCoordinator: detailScreenDismissCoordinator)
        let homeDetailViewController = UIHostingController(rootView: homeDetailScreenView)
        homeDetailViewController.view.accessibilityIdentifier = AccessibiltyIdentifier.HomeDetailViewController.rawValue
        return homeDetailViewController
    }

    // MARK: - View Model
    func makeHomeScreenViewModel() -> HomeScreenViewInputCommonProtocol {
        HomeScreenViewModel(
            homeScreenUsecase: makeHomeScreenUseCase()
        )
    }

    // MARK: - Use Cases
    func makeHomeScreenUseCase() -> StocksListUseCaseProtocol {
        StocksListUseCase(
            stocksListRepository: makeHomeScreenRepository()
        )
    }

    // MARK: - Repositories

    func makeHomeScreenRepository() -> StocksListRepositoryProtocol {
        StocksListRepository(
            dataManager: DataHandler(networkClient: makeDefaultNetorkService(),
                                    cacheManager: CacheManager(name: "Default")),
            networkClient: makeDefaultNetorkService()
        )
    }

    // MARK: - Network Service
    func makeDefaultNetorkService() -> NetworkClientServiceProtocol {
        dependencies.apiNetworkClient
    }

    // MARK: - Flow Coordinators
    func makeHomeScreenCoordinator(
        navigationController: UINavigationController) -> HomeScreenCoordinator
    {
        HomeScreenCoordinator(navigationController: navigationController,
                              dependencies: self)
    }
}
