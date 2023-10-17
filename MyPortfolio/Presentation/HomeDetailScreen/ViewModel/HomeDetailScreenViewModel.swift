//
//  HomeDetailScreenViewModel.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// A view model responsible for managing interactions in the Home Detail Screen.
final class HomeDetailScreenViewModel: HomeDetailScreenViewModelInput {

    /// A delegate for handling favorite button updates.
    weak var favDelegate: UpdateFavouriteDelegate?
    /// A data representing all details to display in details page
    @Published var data: HomeScreenListItemViewData

    /// init of HomeDetailScreenViewModel
    /// - Parameter 
    /// - favDelegate: Delegate confirming from coordinator.
    /// - data: An HomeScreenListItemViewData data coming from the coordinator.
    init(favDelegate: UpdateFavouriteDelegate? = nil,
         data: HomeScreenListItemViewData) {
        self.favDelegate = favDelegate
        self.data = data
    }

    /// Handles the user's tap on the favorite button and updates the data.
    ///
    func userDidTapOnFavourite() {
        // Toggle the favorite status
        let isFavourite = data.isFavourite
        self.data.isFavourite = !isFavourite
        // Notify the delegate about the favorite button update
        favDelegate?.userTappedOnFavouriteButton(data: data)
    }

}
