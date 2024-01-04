//
//  Constants.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// An enumeration of table view cell identifiers used in the app.
///
/// This enumeration defines string values that represent unique identifiers for different table view cells.
/// Each case corresponds to a specific table view cell used in the app.
///
/// - Note: You can use these identifiers to register and dequeue table view cells in your view controller.
internal enum TableViewCellsIds: String {
    /// Identifier for the HomeScreenTableViewCell.
    case homeScreenTableViewCell = "HomeScreenTableViewCell"
}

/// An enumeration representing header titles for navigation bars.
internal enum NavigationHeaderTitle: String {
    /// The header title for the home screen navigation bar.
    case homeScreenTitle = "Stocks Holding"
}

/// An enumeration containing string constants used in the app.
internal enum Strings: String {
    /// The "Last Traded Price" label prefix.
    case ltpRupees = "LTP: ₹"
    /// The "Profit/Loss" label prefix.
    case plRupees = "P/L: ₹"
    /// The label prefix for displaying the current value of an investment.
    case currentValue = "Current Value:"
    /// The label prefix for displaying the total investment amount.
    case totalInvestment = "Total Investment:"
    /// The label prefix for displaying today's profit and loss.
    case todaysPnL = "Today's Profit & Loss:"
    /// The label prefix for displaying profit and loss.
    case profitNLoss = "Profit & Loss:"
    /// The title for an alert message.
    case alert = "Alert"
    /// The title for a retry action.
    case retry = "Retry"
    /// Placeholder text when no value is available.
    case noValue = "-"
    /// The Indian Rupee symbol.
    case rupeeSymbol = "₹"
    /// Stock Detail Header String
    case detailHeader = "Stock Details"
    /// Stock Name String
    case stockName = "Stock Name:"
    /// Stock Quantity String
    case stockQuantity = "Stock Quantity:"
    /// Copy text for fav button accessibility
    case markItAsFavCopyText = "Click to mark it as favourite"
    /// Copy text for un fav button accessibility
    case markItAsUnFavCopyText = "Click to mark it as Un-favourite"

}

/// An enumeration containing CGFloat constants for layout constraints.
internal enum ConstraintConstants: CGFloat {
    case number60 = 60.0
    case number40 = 40.0
    case number30 = 30.0
    case number25 = 25.0
    case number20 = 20.0
    case number18 = 18.0
    case number16 = 16.0
    case number15 = 15.0
    case number10 = 10.0
    case number5 = 5.0
    case number0 = 0.0
}

/// An enumeration representing font names used in the app.
internal enum FontName: String {
    case helveticaBold = "HelveticaNeue-Bold"
    case helvetica = "HelveticaNeue"
}

/// An enumeration containing image names used in the app.
internal enum APP_IMAGES: String {
    case forwardArrow = "ForwardArrow"
    case favFilled = "Favourite-filled"
    case fav = "Favourite"
    case closeButton = "Close"
}

/// An enumeration containing ViewState managed in the app.
internal enum ViewState: Equatable {
    case none
    case loading
    case error(String)
    case content
    case reloadAtParticularRowIndex(Int)
}

/// Defines the state of the profit loss beared
internal enum ProfitLossState {
    case Positive
    case Negative
    case Zero
}

/// Defines an Enum for round off value
internal enum DoubleRoundedOff: Int {
    case roundedTo = 2
}

/// An enumeration containing AccessibiltyIdentifier Names managed in the app.
internal enum AccessibiltyIdentifier: String {
    case HomeAlertMessage
    case HomeDetailViewController
}

internal enum cacheName: String {
    case Portfolio
}
