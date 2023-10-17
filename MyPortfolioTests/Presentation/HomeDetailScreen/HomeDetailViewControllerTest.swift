//
//  HomeDetailViewControllerTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class HomeDetailViewControllerTest: XCTestCase {

    var viewModel: HomeDetailScreenViewModel!
    let loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()
    var viewModelTest: HomeDetailScreenViewModelMockTest!
    var didTapOnFavWithDelegate = false

    override func setUp() {
        if let data = loadHomeScreenListViewData?.data?.first {
            viewModelTest = .init(data: data)
            viewModelTest.favDelegate = self
            viewModel =  HomeDetailScreenViewModel(data: data)
        }
    }

    override func tearDown() {
        viewModel = nil
        viewModelTest = nil
        super.tearDown()
    }

    func test_view_modelData_isNotEmpty() {
        let viewController = HomeDetailScreenView(viewModel: viewModel)
        XCTAssertNotNil(viewController.viewModel.data)
    }

    func test_mock_user_did_tap_on_favourite_btn() {
        // Given
        if var data = loadHomeScreenListViewData?.data?.first {
            data.isFavourite = false
            // When
            viewModelTest.userDidTapOnFavourite()
            // Then
            XCTAssertEqual(didTapOnFavWithDelegate, true)
        }
    }
}

extension HomeDetailViewControllerTest: UpdateFavouriteDelegate {
    func userTappedOnFavouriteButton(data: HomeScreenListItemViewData) {
        didTapOnFavWithDelegate = !data.isFavourite
    }
}

final class HomeDetailScreenViewModelMockTest: HomeDetailScreenViewModelInput {
    var data: HomeScreenListItemViewData
    weak var favDelegate: UpdateFavouriteDelegate?

    init(data: HomeScreenListItemViewData, favDelegate: UpdateFavouriteDelegate? = nil) {
        self.data = data
        self.favDelegate = favDelegate
    }

    func userDidTapOnFavourite() {
        favDelegate?.userTappedOnFavouriteButton(data: data)
    }
}
