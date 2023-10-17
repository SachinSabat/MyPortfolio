//
//  HomeScreenListViewData.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// A data structure for holding a list of items on the Home Screen.
struct HomeScreenListViewData {
    /// An array of HomeScreenListItemViewData items.
    var data: [HomeScreenListItemViewData]?
    var dataCount: Int?
}

extension HomeScreenListViewData {
    /// Initializes a HomeScreenListViewData instance from a list of StocksItemDataDomainModel.
    ///
    /// - Parameter stocksData: An array of  StocksItemUseCaseCommonDataProtocol which is of type StocksItemDataDomainModel.
    init(stocksData: [StocksItemUseCaseCommonDataProtocol]) {
        self.data = stocksData.compactMap({ stocks in
            HomeScreenListItemViewData.init(stocks: stocks)
        })
        self.dataCount = data?.count
    }
}

/// A data structure for representing individual items on the Home Screen.
/// Confirms to StocksItemUseCaseCommonDataProtocol
struct HomeScreenListItemViewData: StocksItemUseCaseCommonDataProtocol {
    let quantity: Double?
    let symbol: String?
    let ltp: Double?
    let avg_price: String?
    let previous_close: Double?
    var isFavourite: Bool = false
    var atIndex: Int = 0
    var currentIndValue: Double
    var investmentIndValue: Double
    var profitNLoss: Double
}

extension HomeScreenListItemViewData {

    /// Initializes a HomeScreenListItemViewData instance from a StocksItemDataDomainModel.
    ///
    /// - Parameter stocks: A StocksItemUseCaseCommonDataProtocol object of type StocksItemDataDomainModel.
    init(stocks: StocksItemUseCaseCommonDataProtocol) {
        self.quantity = stocks.quantity
        self.symbol = stocks.symbol
        self.ltp = stocks.ltp?.roundToDecimal(DoubleRoundedOff.roundedTo.rawValue)
        self.avg_price = stocks.avg_price
        self.previous_close = stocks.previous_close
        self.currentIndValue = stocks.currentIndValue
        self.investmentIndValue = stocks.investmentIndValue
        self.profitNLoss = stocks.profitNLoss.roundToDecimal(DoubleRoundedOff.roundedTo.rawValue)
    }
}
