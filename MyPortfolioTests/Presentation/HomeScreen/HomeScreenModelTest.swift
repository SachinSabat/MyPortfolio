//
//  HomeScreenModelTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class HomeScreenModelTest: XCTestCase {

    private(set) var data = [HomeScreenListItemViewData]()
    var homeScreenModel: HomeScreenListViewData?
    let loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()

    override func setUp() {
        if let data = loadHomeScreenListViewData?.data {
            self.data = data
        }
        homeScreenModel = loadHomeScreenListViewData
    }

    override func tearDown() {
        homeScreenModel = nil
        data = []
        super.tearDown()
    }

    func test_homeScreenModel_not_nil() {
        XCTAssertNotNil(data)
        XCTAssertNotNil(homeScreenModel)
    }

    func test_homeScreenModel_positive_scenario() {
        XCTAssertFalse(data.isEmpty)
        let stockData = data[0]
        XCTAssertEqual(stockData.symbol, "IRFC")
        XCTAssertEqual(homeScreenModel?.data?.count, 4)
        XCTAssertEqual(homeScreenModel?.dataCount, 4)
    }

    func test_homeScreenModel_negaitive_scenario() {
        XCTAssertFalse(data.isEmpty)
        homeScreenModel?.data = nil
        XCTAssertEqual(homeScreenModel?.data?.count, nil)
    }

    func test_privateSetData() {
        let stockData = data[0]
        XCTAssertEqual(stockData.quantity, 575.0)
        XCTAssertEqual(stockData.avg_price, "26.00")
        XCTAssertEqual(stockData.ltp, 100.5)
    }
}
