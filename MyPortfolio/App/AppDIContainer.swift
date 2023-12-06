//
//  AppDIContainer.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
import NetworkManager

protocol AppDIContainerProtocol {
    /// A property representing the network client service used for making API requests.
    var apiNetworkClient: NetworkClientServiceProtocol { get }
    /**
     Creates a dependency injection container for the Home Screen module.
     The Home Screen DI container is responsible for managing the dependencies required.
     - Returns: An instance of `HomeScreenDIContainer`.
     */
    func makeHomeScreenDIContainer() -> HomeScreenDIContainer
}

/// A DI (Dependency Injection) container for managing dependencies in the application.
final class AppDIContainer: AppDIContainerProtocol {

    // MARK: - Network
    /// A lazily initialized instance of the API Network Service.
    lazy var apiNetworkClient: NetworkClientServiceProtocol = {
        let networkService = NetworkService()
        return NetworkClient(with: networkService)
    }()

    // MARK: - DIContainers of screen
    /// Creates and returns a DI container for the Home Screen.
    ///
    /// - Returns: A `HomeScreenDIContainer` instance.
    func makeHomeScreenDIContainer() -> HomeScreenDIContainer {
        let dependencies = HomeScreenDIContainer.Dependencies(
            apiNetworkClient: apiNetworkClient
        )
        return HomeScreenDIContainer(dependencies: dependencies)
    }
}
