//
//  HomeScreenViewModelTests.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class HomeScreenViewModelTests: XCTestCase {

    var network: NetworkClientServiceProtocol!
    var viewModel: HomeScreenViewModel!
    var useCase: StocksListUseCase!
    var repository: StocksListRepository!
    var homeScreenDataModel: [HomeScreenListItemViewData]?
    let loadHomeScreenListViewData  = StockUtils().loadHomeScreenListViewData()
    let loadArrStocksItemDataDomainModel  = StockUtils().loadArrStocksItemDataDomainModel()

    override func setUp() {
        network = NetworkClientServiceMock()
        repository = .init(networkClient: network!)
        useCase = .init(stocksListRepository: repository, stocksListDataModel: loadArrStocksItemDataDomainModel)
        self.homeScreenDataModel =  loadHomeScreenListViewData?.data
        viewModel = .init(homeScreenUsecase: useCase)
    }

    override func tearDown() {
        viewModel = nil
        homeScreenDataModel = []
        network = nil
        useCase = nil
        repository = nil
        super.tearDown()
    }

    func test_getHomeScreenData_positive_scenario() {
        /// Given
        let expectation = XCTestExpectation(description: "getHomeScreenData")
        /// When
        viewModel.getHomeScreenData()
        /// Then
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            XCTAssertNotNil(self.useCase.stocksListDataModel)
            XCTAssertEqual(self.useCase.stocksListDataModel?.count, 4)
            XCTAssertNotNil(self.viewModel.homeScreenDataModel?.data)
            XCTAssertEqual(self.viewModel.homeScreenDataModel?.dataCount, 4)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func test_getHomeScreenData_negative_scenario() {
        /// Given
        let expectation = XCTestExpectation(description: "getHomeScreenData")
        let networkService = NetworkService(
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: nil,
                error: NetworkError.unknown
            )
        )
        let networkCLient = NetworkClient(with: networkService)
        let repository = StocksListRepository(networkClient: networkCLient)
        let usecase = StocksListUseCase(stocksListRepository: repository)
        /// When
        viewModel = .init(homeScreenUsecase: usecase)
        viewModel.getHomeScreenData()
        /// Then
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            XCTAssertNil(usecase.stocksListDataModel)
            XCTAssertEqual(usecase.stocksListDataModel?.count, nil)
            XCTAssertNil(self.viewModel.homeScreenDataModel?.data)
            XCTAssertEqual(self.viewModel.homeScreenDataModel?.dataCount, nil)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2)
    }

    func test_getNumberOfRows_postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase, homeScreenDataModel: loadHomeScreenListViewData)
        /// When
        let rowCount = viewModel.getNumberOfRows()
        /// Then
        XCTAssertEqual(viewModel.homeScreenDataModel?.data?.count, 4)
        XCTAssertEqual(viewModel.homeScreenDataModel?.dataCount, 4)
        XCTAssertEqual(viewModel.homeScreenDataModel?.dataCount, rowCount)
    }

    func test_getNumberOfRows_negative_scenario() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: .init())
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let rowCount = viewModel.getNumberOfRows()
        /// Then
        XCTAssertEqual(viewModel.homeScreenDataModel?.data?.count, nil)
        XCTAssertEqual(viewModel.homeScreenDataModel?.dataCount, nil)
        XCTAssertEqual(0, rowCount)
    }

    func test_getNumberOfRows_postive_scenario_nil_data() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: nil)
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let rowCount = viewModel.getNumberOfRows()
        /// Then
        XCTAssertEqual(viewModel.homeScreenDataModel?.data?.count, nil)
        XCTAssertEqual(viewModel.homeScreenDataModel?.dataCount, nil)
        XCTAssertEqual(0, rowCount)

    }

    func test_getDataForParticularRow_postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: self.useCase, homeScreenDataModel: loadHomeScreenListViewData)
        /// When
        let data = viewModel.getDataForParticularRow(indexPathforRow: 1)
        /// Then
        XCTAssertNotNil(data)
        XCTAssertEqual(data?.symbol, "BANDHANBNK")
    }

    func test_getDataForParticularRow_negative_scenario() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: nil)
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let data = viewModel.getDataForParticularRow(indexPathforRow: 1)
        /// Then
        XCTAssertNil(data)
        XCTAssertEqual(data?.symbol, nil)
    }


    func test_getAllCurrentValue__postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let currentValue = viewModel.getAllCurrentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 78900.0)
    }

    func test_getAllCurrentValue_negative_scenario() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: [])
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let currentValue = viewModel.getAllCurrentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 0.0)
    }

    func test_getAllCurrentValue_negative_scenario_nil_data() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: nil)
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let currentValue = viewModel.getAllCurrentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 0.0)
    }

    func test_getAllInvestmentValue_postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let currentValue = viewModel.getAllInvestmentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 302.68)
    }

    func test_getAllInvestmentValue_negative_scenario() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: [])
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let currentValue = viewModel.getAllInvestmentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 0.0)
    }

    func test_getAllInvestmentValue_negative_scenario_nil_data() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: nil)
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let currentValue = viewModel.getAllInvestmentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 0.0)
    }

    func test_getTotalPnL_postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let (profitNLoss, profitNLossState) = viewModel.getTotalPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, 78597.32)
        XCTAssertEqual(profitNLossState, .Positive)
    }

    func test_getTotalPnL_negative_scenario() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: [])
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let (profitNLoss, profitNLossState) = viewModel.getTotalPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, 0.0)
        XCTAssertEqual(profitNLossState, .Zero)
    }

    func test_getTotalPnL_negative_scenario_nil_data() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: nil)
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let (profitNLoss, profitNLossState) = viewModel.getTotalPnL() ?? (nil, nil)
        /// Then
        XCTAssertNil(profitNLoss)
        XCTAssertNil(profitNLossState)
        XCTAssertEqual(profitNLoss, nil)
        XCTAssertEqual(profitNLossState, nil)
    }

    func test_getTodaysPnL_postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase)
        /// When
        let (profitNLoss, profitNLossState) = viewModel.getTodaysPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, -50254.05)
        XCTAssertEqual(profitNLossState, .Negative)
    }

    func test_getTodaysPnL_negative_scenario() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: [])
        viewModel = .init(homeScreenUsecase: useCase)

        /// When
        let (profitNLoss, profitNLossState) = viewModel.getTodaysPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, 0.0)
        XCTAssertEqual(profitNLossState, .Zero)
    }

    func test_getTodaysPnL_negative_scenario_nil_data() {
        /// Given
        useCase = .init(stocksListRepository: repository, stocksListDataModel: nil)
        viewModel = .init(homeScreenUsecase: useCase)

        /// When
        let (profitNLoss, profitNLossState) = viewModel.getTodaysPnL() ?? (nil, nil)
            /// Then
            XCTAssertNil(profitNLoss)
            XCTAssertNil(profitNLossState)
            XCTAssertEqual(profitNLoss, nil)
            XCTAssertEqual(profitNLossState, nil)
    }


    func test_userDidTapOnFavourite_postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase, homeScreenDataModel: loadHomeScreenListViewData)
        /// When
        viewModel.userDidTapOnFavourite(at: 2)
        /// Then
        XCTAssertEqual(viewModel.getDataForParticularRow(indexPathforRow: 2)?.isFavourite, true)
    }

    func test_userDidTapOnFavourite_negative_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase, homeScreenDataModel: loadHomeScreenListViewData)

        /// When
        viewModel.userDidTapOnFavourite(at: 1)
        /// Then
        XCTAssertEqual(viewModel.getDataForParticularRow(indexPathforRow: 2)?.isFavourite, false)
    }

    func test_userDidTapOnFavourite_array_index_out_of_range_dataCount() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase)
        homeScreenDataModel?[1].isFavourite = true

        /// When
        viewModel.userDidTapOnFavourite(at: 5)
        /// Then
        XCTAssertEqual(homeScreenDataModel?[1].isFavourite, true)
    }

    func test_updateUserFavModel_postive_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase)
        homeScreenDataModel?[1].atIndex = 1
        /// When
        viewModel.updateUserFavModel(data: homeScreenDataModel![1])
        /// Then
        XCTAssertEqual(homeScreenDataModel?[1].atIndex, 1)
    }

    func test_updateUserFavModel_negative_scenario() {
        /// Given
        viewModel = .init(homeScreenUsecase: useCase)
        homeScreenDataModel?[1].atIndex = 2
        /// When
        viewModel.updateUserFavModel(data: homeScreenDataModel![1])
        /// Then
        XCTAssertNotEqual(homeScreenDataModel?[1].atIndex, 3)
    }
}
