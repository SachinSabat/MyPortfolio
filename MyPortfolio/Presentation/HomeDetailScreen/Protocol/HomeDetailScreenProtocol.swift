//
//  HomeDetailScreenProtocol.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// A protocol defining the output methods for the Home Detail Screen View Model.
protocol HomeDetailScreenViewModelOutput: AnyObject {
    /// Notifies the view to update the favorite button with the provided data.
    ///
    /// - Parameter data: The updated Home Screen List View Data Model.
    func updateFavouriteButton(data: HomeScreenListItemViewData)
}

/// A protocol defining the input methods and properties for the Home Detail Screen View Model.
protocol HomeDetailScreenViewModelInput: AnyObject, ObservableObject {

    /// A delegate for handling favorite button updates.
    var favDelegate: UpdateFavouriteDelegate? { get }

    /// Handles the user's tap on the favorite button and updates the data.
    ///
    /// - Parameter data: An inout parameter for the Home Screen List View Data Model.
    func userDidTapOnFavourite()
    
    /// A data representing all details to display in details page
    var data: HomeScreenListItemViewData { get }
}

/// A protocol for the delegate that handles favorite button updates.
protocol UpdateFavouriteDelegate: AnyObject {
    /// Notifies the delegate that the user has tapped on the favorite button with the provided data.
    ///
    /// - Parameter data: The Home Screen List View Data Model.
    func userTappedOnFavouriteButton(data: HomeScreenListItemViewData)
}
