//
//  MyPortfolioUITests.swift
//  MyPortfolioUITests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest

final class MyPortfolioUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var totalInvestment: XCUIElement!
    private var currentValue: XCUIElement!
    private var todaysPL: XCUIElement!
    private var totalPL: XCUIElement!
    private var irfc: XCUIElement!
    private var nationlum: XCUIElement!
    private var closeButton: XCUIElement!
    private var stockHeader: XCUIElement!
    private var stockName: XCUIElement!
    private var alert: XCUIElement!
    private var tableViewElementsQuery: XCUIElementQuery!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        totalInvestment = app.staticTexts["Total Investment:"]
        currentValue = app.staticTexts["Current Value:"]
        todaysPL = app.staticTexts["Today's Profit & Loss:"]
        totalPL = app.staticTexts["Profit & Loss:"]
        irfc = app.tables.staticTexts["IRFC"]
        nationlum = app.tables.staticTexts["NATIONALUM"]
        /// Detail header View
        closeButton = app.buttons["Close"]
        stockHeader = app.staticTexts["Stock Details"]
        stockName = app.staticTexts["Stock Name:"]
        alert = app.alerts["HomeAlertMessage"]
        tableViewElementsQuery = app.tables.cells.otherElements
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
        try super.tearDownWithError()
    }

    // Use XCTAssert and related functions to verify your tests produce the correct results.
    func test_HomeScreenElements() throws {

        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertTrue(irfc.isEnabled)
        XCTAssertTrue(nationlum.isEnabled)
        XCTAssertTrue(totalInvestment.exists)
        XCTAssertTrue(currentValue.exists)
        XCTAssertTrue(totalPL.exists)
        XCTAssertTrue(todaysPL.exists)

        let bandhanbnkElementsQuery = tableViewElementsQuery.containing(.staticText, identifier:"BANDHANBNK")
        bandhanbnkElementsQuery.buttons["Favourite"].tap()
        XCTAssertTrue(bandhanbnkElementsQuery.buttons["Favourite filled"].isEnabled)
        XCTAssertTrue(bandhanbnkElementsQuery.buttons["Favourite filled"].exists)
        bandhanbnkElementsQuery.buttons["Favourite filled"].tap()
        XCTAssertTrue(bandhanbnkElementsQuery.buttons["Favourite"].isEnabled)
        XCTAssertTrue(bandhanbnkElementsQuery.buttons["Favourite"].exists)

        homePageScreenShot()
    }

    func test_HomeDetailScreenElements() {
        irfc.tap()

        XCTAssertTrue(app.otherElements["HomeDetailViewController"].waitForExistence(timeout: 1), "Not presented")

        XCTAssertTrue(closeButton.isEnabled)
        XCTAssertTrue(stockHeader.isEnabled)
        XCTAssertTrue(stockName.exists)

        detailPageScreenShot()
    }

    private func detailPageScreenShot() {
        let detailPageScreenShot = XCUIScreen.main.screenshot()
        let detailScreenAttachment = XCTAttachment(screenshot: detailPageScreenShot)
        detailScreenAttachment.name = "Detail Page Screen shot"
        detailScreenAttachment.lifetime = .keepAlways
        add(detailScreenAttachment)
    }

    private func homePageScreenShot() {
        let homePageScreenShot = XCUIScreen.main.screenshot()
        let homeScreenAttachment = XCTAttachment(screenshot: homePageScreenShot)
        homeScreenAttachment.name = "Home Page Screen shot"
        homeScreenAttachment.lifetime = .keepAlways
        add(homeScreenAttachment)
    }
}

