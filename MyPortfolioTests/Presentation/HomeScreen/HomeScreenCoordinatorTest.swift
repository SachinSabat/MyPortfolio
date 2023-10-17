//
//  HomeScreenCoordinatorTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class HomeScreenCoordinatorTest: XCTestCase {

    private var coordinator: HomeScreenCoordinator!
    let loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()
    private var coordinatorMock: HomeScreenCoordinatorMockTest!

    override func setUp() {
        super.setUp()
        let navigationController
        = UINavigationController(rootViewController: UIViewController())
        coordinator = .init(navigationController: navigationController, 
                            dependencies: HomeScreenDIContainer(dependencies: .init(apiNetworkClient: NetworkClientServiceMock())))
        coordinatorMock = HomeScreenCoordinatorMockTest(navigationController: navigationController)
    }

    override func tearDown() {
        coordinator = nil
        coordinatorMock = nil
        super.tearDown()
    }

    func test_mock_coordinateToDetailScreen() {
        if let data = loadHomeScreenListViewData?.data?.first {
            coordinatorMock.coordinateToDetailScreen(data: data,
                                                     delegate: self)
            XCTAssertTrue(coordinatorMock.myVCCalled)
            XCTAssertNotNil(coordinatorMock.homeScreenListItemViewData)
        }
    }

    func test_coordinateToDetailScreen() {
        if let data = loadHomeScreenListViewData?.data?.first {
            XCTAssertNoThrow(
                coordinator.coordinateToDetailScreen(data: data, delegate: self)
            )
        }
    }
}

final class HomeScreenCoordinatorMockTest: Coordinator, HomeDetailScreenFlow {

    var navigationController: UINavigationController
    var myVCCalled = false
    var homeScreenListItemViewData: HomeScreenListItemViewData!

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

    }

    func coordinateToDetailScreen(data: HomeScreenListItemViewData,
                                  delegate: UpdateFavouriteDelegate) {
        myVCCalled = true
        homeScreenListItemViewData = data
    }

}

extension HomeScreenCoordinatorTest: UpdateFavouriteDelegate {
    func userTappedOnFavouriteButton(data: HomeScreenListItemViewData) {

    }
}
