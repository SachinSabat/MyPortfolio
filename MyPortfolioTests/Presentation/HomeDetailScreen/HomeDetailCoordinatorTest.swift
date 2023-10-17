//
//  HomeDetailCoordinatorTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class HomeDetailCoordinatorTest: XCTestCase {

    private var coordinatorMock: HomeDetailCoordinatorMockTest!
    private var coordinator: HomeDetailCoordinator!
    let loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()

    override func setUp() {
        super.setUp()

        let navigationController = UINavigationController(rootViewController: UIViewController())
        coordinatorMock = HomeDetailCoordinatorMockTest(navigationController: navigationController)

        if let homeScreenListData = loadHomeScreenListViewData?.data?.first {
            coordinator = .init(navigationController: navigationController,
                                data: homeScreenListData,
                                delegate: self, dependencies: HomeScreenDIContainer(dependencies: .init(apiNetworkClient: NetworkClientServiceMock())))
        }
    }

    override func tearDown() {
        coordinatorMock = nil
        coordinator = nil
        super.tearDown()
    }

    func test_Mock_DismissDetailScreen() {
        coordinatorMock.dismissDetailPage()
        XCTAssertTrue(coordinatorMock.myVCCalled)
    }

    func test_dataExitsWhilePresentingDetailScreen() {
        coordinator.start()
        XCTAssertNotNil(coordinator.data)
        XCTAssertNotNil(coordinator.navigationController)
    }

    func test_coordinateToDismissDetailScreen() {
        XCTAssertNoThrow(
            coordinator.dismissDetailPage()
        )
    }
}

final class HomeDetailCoordinatorMockTest: Coordinator, DetailScreenDismissFlow {

    var navigationController: UINavigationController
    var myVCCalled = false

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {

    }

    func dismissDetailPage() {
        myVCCalled = true
    }

}


extension HomeDetailCoordinatorTest: UpdateFavouriteDelegate{

    func userTappedOnFavouriteButton(data: HomeScreenListItemViewData) {

    }
}
