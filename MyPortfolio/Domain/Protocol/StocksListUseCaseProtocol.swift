//
//  StocksListUseCaseProtocol.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//
import Combine
import NetworkManager
/// typealias to have Interface segregation in our code for Stocks list use case
typealias StocksListUseCaseProtocol = GetStocksListUseCaseProtocol & StocksListCommonUseCaseProtocol

/// Types conforming to `GetStocksListUseCaseProtocol` are responsible for executing the use case to retrieve stocks list data.
protocol GetStocksListUseCaseProtocol {
    /// Fetches data for the stocks list.
    func executeStocksListData() -> AnyPublisher<StocksListDomainModel, NetworkError>
    func executeAllFooterData(stocksListDomainModel: StocksListDomainModel)
}

protocol StocksListCommonUseCaseProtocol {

    /// Retrieves the total current value of all data items.
    ///
    /// - Returns: The total current value.
    func getAllCurrentValue() -> Double

    /// Retrieves the total investment value of all data items.
    ///
    /// - Returns: The total investment value.
    func getAllInvestmentValue() -> Double

    /// Retrieves the total profit and loss value.
    ///
    /// - Returns: The total profit and loss value with its state.
    func getTotalPnL() -> (Double, ProfitLossState)?

    /// Retrieves today's profit and loss value.
    ///
    /// - Returns: Today's profit and loss value with its state.
    func getTodaysPnL() -> (Double, ProfitLossState)?
}
