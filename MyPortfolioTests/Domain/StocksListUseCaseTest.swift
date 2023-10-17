//
//  StocksListUseCaseTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class StocksListUseCaseTest: XCTestCase {

    let data = StockUtils().loadStocksListDomainModel()
    let loadArrStocksItemDataDomainModel = StockUtils().loadArrStocksItemDataDomainModel()

    func test_success_for_api_request() {
        /// Given
        var useCaseCompletionCallsCount = 0
        let stocksListRepository = StocksListRepositoryMock(
            result: .success(data)
        )

        let useCase = StocksListUseCase(
            stocksListRepository: stocksListRepository
        )

        /// When
        useCase.executeStocksListData() { _ in
            useCaseCompletionCallsCount += 1
        }

        /// Then
        XCTAssertNotNil(useCase.stocksListDataModel)
        XCTAssertEqual(useCase.stocksListDataModel?.count, 4)
        XCTAssertEqual(useCaseCompletionCallsCount, 1)
        XCTAssertEqual(stocksListRepository.fetchCompletionCallsCount, 1)
    }

    func test_failed_for_api_request() {
        /// Given
        var useCaseCompletionCallsCount = 0
        let stocksListRepository = StocksListRepositoryMock(
            result: .failure(.unknown)
        )

        let useCase = StocksListUseCase(
            stocksListRepository: stocksListRepository
        )

        /// When
        useCase.executeStocksListData() { _ in
            useCaseCompletionCallsCount += 1
        }

        /// Then
        XCTAssertNil(useCase.stocksListDataModel)
        XCTAssertEqual(useCase.stocksListDataModel?.count, nil)
        XCTAssertEqual(useCaseCompletionCallsCount, 1)
        XCTAssertEqual(stocksListRepository.fetchCompletionCallsCount, 1)
    }

    func test_getAllCurrentValue__postive_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: loadArrStocksItemDataDomainModel
        )
        /// When
        let current = useCase.getAllCurrentValue()
        /// Then
        XCTAssertNotNil(current)
        XCTAssertEqual(current, 78900.0)
    }

    func test_getAllCurrentValue_negative_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: nil
        )
        /// When
        let currentValue = useCase.getAllCurrentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 0.0)
    }

    func test_getAllInvestmentValue_postive_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: loadArrStocksItemDataDomainModel
        )
        /// When
        let currentValue = useCase.getAllInvestmentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 302.68)
    }

    func test_getAllInvestmentValue_negative_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: nil
        )
        /// When
        let currentValue = useCase.getAllInvestmentValue()
        /// Then
        XCTAssertNotNil(currentValue)
        XCTAssertEqual(currentValue, 0.0)
    }

    func test_getTotalPnL_postive_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: loadArrStocksItemDataDomainModel
        )
        /// When
        let (profitNLoss, profitNLossState) = useCase.getTotalPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, 78597.32)
        XCTAssertEqual(profitNLossState, .Positive)
    }

    func test_getTotalPnL_negative_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: []
        )
        /// When
        let (profitNLoss, profitNLossState) = useCase.getTotalPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, 0.0)
        XCTAssertEqual(profitNLossState, .Zero)
    }

    func test_getTodaysPnL_postive_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: loadArrStocksItemDataDomainModel
        )
        /// When
        let (profitNLoss, profitNLossState) = useCase.getTodaysPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, -50254.05)
        XCTAssertEqual(profitNLossState, .Negative)
    }

    func test_getTodaysPnL_negative_scenario() {
        /// Given
        let repository = StocksListRepository(
            networkClient: NetworkClientServiceMock()
        )

        let useCase = StocksListUseCase(
            stocksListRepository: repository,
            stocksListDataModel: []
        )
        /// When
        let (profitNLoss, profitNLossState) = useCase.getTodaysPnL()!
        /// Then
        XCTAssertNotNil(profitNLoss)
        XCTAssertNotNil(profitNLossState)
        XCTAssertEqual(profitNLoss, 0.0)
        XCTAssertEqual(profitNLossState, .Zero)
    }

}

final class StocksListRepositoryMock: StocksListRepositoryProtocol {

    var result: Result<StocksListDomainModel, NetworkError>
    var fetchCompletionCallsCount = 0

    init(result: Result<StocksListDomainModel, NetworkError>) {
        self.result = result
    }

    func fetchStocksList(completion: @escaping (Result<StocksListDomainModel, NetworkError>) -> Void) -> URLSessionDataTask? {
        completion(result)
        fetchCompletionCallsCount += 1
        return nil
    }
}
