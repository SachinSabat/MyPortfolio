//
//  HomeDetailScreenViewModelTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class HomeDetailScreenViewModelTest: XCTestCase {

    var viewModel: HomeDetailScreenViewModel!
    private(set) var data: HomeScreenListItemViewData?
    let loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()

    override func setUp() {
        if let data = loadHomeScreenListViewData?.data?.first {
            self.data = data
            viewModel = .init(data: data)
        }
    }

    override func tearDown() {
        viewModel = nil
        data = nil
        super.tearDown()
    }

    func test_userDidTapOnFavourite_Positive_Scenario() {
        // Given
        if var data = self.data {
            data.isFavourite = false
            viewModel = .init(data: data)
            // When
            viewModel.userDidTapOnFavourite()
            // Then
            XCTAssertEqual(viewModel.data.isFavourite, true)
        }
    }

    func test_userDidTapOnFavourite_Negative_Scenario() {
        // Given
        if var data = self.data {
            data.isFavourite = true
            viewModel = .init(data: data)
            // When
            viewModel.userDidTapOnFavourite()
            // Then
            XCTAssertEqual(viewModel.data.isFavourite, false)
        }
    }

}
