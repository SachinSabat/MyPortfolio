//
//  StocksListUseCase.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// A use case responsible for fetching data for the portfolio stocks list.
final class StocksListUseCase: StocksListUseCaseProtocol {
    /// The network client used for API requests.
    private let stocksListRepository: StocksListRepositoryProtocol
    /// The data model representing the stocks list data.
    var stocksListDataModel: [StocksItemDataDomainModel]?

    /// Initializes a new `StocksListUseCase` instance.
    init(
        stocksListRepository: StocksListRepositoryProtocol,
        stocksListDataModel: [StocksItemDataDomainModel]? = nil
    ) {
        self.stocksListRepository = stocksListRepository
        self.stocksListDataModel = stocksListDataModel
    }

    /// Fetches data for the stocks list.
    ///
    /// - Important: This method uses the `stocksListRepository` to fetch home screen data and calls the completion handler with the result.
    ///
    /// - Parameter completion: A closure that is called once the data retrieval is complete, providing a `Result` type containing either the `StocksListDomainModel` or a `NetworkError`.
    ///
    func executeStocksListData(
        completion: @escaping (Result<StocksListDomainModel, NetworkError>) -> Void
    ) {
        stocksListRepository.fetchStocksList { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(response):
                self.updateDataArray(response)
                completion(result)
            default:
                completion(result)
            }
        }
    }

    /// Updates the data array with the fetched data and notifies the view to update.
    private func updateDataArray(_ stocksListDomainModel: StocksListDomainModel) {
        if let data = stocksListDomainModel.data  {
            self.stocksListDataModel = data
        }
    }
}

extension StocksListUseCase {
    /// Retrieves All current value of all data items.
    func getAllCurrentValue() -> Double {
        guard let stocksListDataModel = stocksListDataModel else {
            return .zero
        }
        let allCurrentValue = stocksListDataModel.lazy.compactMap({
            $0.currentIndValue
        }).reduce(.zero, +)
        return allCurrentValue
            .roundToDecimal(DoubleRoundedOff.roundedTo.rawValue)
    }

    /// Retrieves the total investment value of all data items.
    func getAllInvestmentValue() -> Double {
        guard let stocksListDataModel = stocksListDataModel else {
            return .zero
        }
        let allInvestmentValue = stocksListDataModel.lazy.compactMap({
            $0.investmentIndValue
        }).reduce(.zero, +)
        return allInvestmentValue
            .roundToDecimal(DoubleRoundedOff.roundedTo.rawValue)
    }

    /// Retrieves the total profit and loss value.
    func getTotalPnL() -> (Double, ProfitLossState)? {
        guard let _ = stocksListDataModel else {
            return nil
        }
        let currentValue = getAllCurrentValue()
        let investmentValue = getAllInvestmentValue()
        let totalPnL = currentValue - investmentValue
        let profitLossState = getProfitLossState(profitAndLoss: totalPnL)
        return (totalPnL.roundToDecimal(DoubleRoundedOff.roundedTo.rawValue),
                profitLossState)
    }

    /// Calculates and set the Profit and loss state
    private func getProfitLossState(profitAndLoss: Double) -> ProfitLossState {
        let profitLossState: ProfitLossState = profitAndLoss.sign == .minus ?
            .Negative : profitAndLoss == .zero ? .Zero : .Positive
        return profitLossState
    }

}

extension StocksListUseCase {
    /// Retrieves today's profit and loss value.
    func getTodaysPnL() -> (Double, ProfitLossState)? {
        guard let _ = stocksListDataModel else {
            return nil
        }
        let sumOfClose = self.getSumOfClose()
        let sumOfLTP = self.getSumOfLTP()
        let sumOfQuantity = self.getSumOfQuantity()

        let todaysPnL = (sumOfClose - sumOfLTP) * sumOfQuantity
        let profitLossState = getProfitLossState(profitAndLoss: todaysPnL)
        return (todaysPnL.roundToDecimal(DoubleRoundedOff.roundedTo.rawValue),
                profitLossState)
    }

    /// Calculates and returns the sum of "close" values in the data.
    private func getSumOfClose() -> Double {
        guard let stocksListDataModel = stocksListDataModel,
              !stocksListDataModel.isEmpty else {
            return .zero
        }
        let sumOfClose = stocksListDataModel.lazy.compactMap({
            $0.previous_close
        }).reduce(.zero, +)
        return sumOfClose
    }

    /// Calculates and returns the sum of "LTP" (Last Trade Price) values in the data.
    private func getSumOfLTP() -> Double {
        guard let stocksListDataModel = stocksListDataModel,
              !stocksListDataModel.isEmpty else {
            return .zero
        }
        let sumOfLTP = stocksListDataModel.lazy.compactMap({
            $0.ltp
        }).reduce(.zero, +)
        return sumOfLTP
    }

    /// Calculates and returns the sum of "quantity" values in the data.
    private func getSumOfQuantity() -> Double {
        guard let stocksListDataModel = stocksListDataModel,
              !stocksListDataModel.isEmpty else {
            return .zero
        }
        let sumOfQuantity = stocksListDataModel.lazy.compactMap({
            $0.quantity
        }).reduce(.zero, +)
        return sumOfQuantity
    }
}
