//
//  StocksListDomainModel.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/**
 A protocol defining common properties for a stock item in a financial application.
 The `StocksItemUseCaseCommonDataProtocol` provides a set of properties that can be used to represent essential information about a stock item, 
 such as its quantity, symbol, last traded price (LTP), average price, previous closing price, and various financial metrics.
 */
protocol StocksItemUseCaseCommonDataProtocol {
    /// The quantity of the stock item.
    var quantity: Double? {get}
    /// The symbol or ticker of the stock item.
    var symbol: String? {get}
    /// The last traded price of the stock item.
    var ltp: Double? {get}
    /// The average price of the stock item.
    var avg_price: String? {get}
    /// The previous closing price of the stock item.
    var previous_close: Double? {get}
    /// The current individual value of the stock item.
    var currentIndValue: Double {get}
    /// The investment individual value of the stock item.
    var investmentIndValue: Double {get}
    /// The profit or loss value of the stock item.
    var profitNLoss: Double {get}
}

// MARK: - Data Domain Object
/// A data model representing the data for the stocks list.
struct StocksListDomainModel: Equatable {
    /// An array of `StocksItemDataDomainModel` objects containing stocks list data.
    var data: [StocksItemDataDomainModel]?
}

/// Represents data for an item for the stocks list.
struct StocksItemDataDomainModel: Equatable, StocksItemUseCaseCommonDataProtocol {
    let quantity: Double?
    let symbol: String?
    let ltp: Double?
    let avg_price: String?
    let previous_close: Double?
    var currentIndValue: Double = .zero
    var investmentIndValue: Double = .zero
    var profitNLoss: Double = .zero

    init(quantity: Double?, symbol: String?, ltp: Double?, avg_price: String?, previous_close: Double?) {
        self.quantity = quantity
        self.symbol = symbol
        self.ltp = ltp
        self.avg_price = avg_price
        self.previous_close = previous_close
        // Calculations to store Current, Investment & ProfitNLoss value
        if let ltp = self.ltp,
            let quantity = self.quantity
        {
            self.currentIndValue = ltp * quantity
        }
        if let avg_price = self.avg_price,
            let doubleAvgPrice = Double(avg_price),
            let quantity = self.quantity
        {
            self.investmentIndValue = doubleAvgPrice - quantity
        }
        self.profitNLoss = self.currentIndValue - self.investmentIndValue
    }
}
