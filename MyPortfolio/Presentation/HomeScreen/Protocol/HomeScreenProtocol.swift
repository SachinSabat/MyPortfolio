//
//  HomeScreenProtocol.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

/// typealias to have Interface segregation in our code for Home screen view model input
typealias HomeScreenViewInputCommonProtocol = HomeScreenViewModelInput & StocksListCommonUseCaseProtocol

//Blueprint of whole home screen module
/// A protocol defining the output methods for a Home Screen View Model.
protocol HomeScreenViewModelOutput: AnyObject {
    /// Notifies the view to update its data.
    func updateData()

    /// Performs action based on state change.
    ///
    /// - Parameter state: Performa action once the state changes.
    func changeViewState(_ state: ViewState)
}

/// A protocol defining the input methods for a Home Screen View Model.
protocol HomeScreenViewModelInput: AnyObject {
    /// Cell type for a particular tableView
    var cellType: String { get }

    /// The view associated with the view model.
    var viewDelegate: HomeScreenViewModelOutput? { get set }

    /// Fetches data for the home screen.
    func getHomeScreenData()

    /// Retrieves the number of rows in the data.
    ///
    /// - Returns: The number of rows in the data.
    func getNumberOfRows() -> Int

    /// Retrieves data for a specific row at the given index.
    ///
    /// - Parameter indexPathforRow: The index of the row.
    /// - Returns: The data model for the specified row.
    func getDataForParticularRow(indexPathforRow: Int) -> HomeScreenListItemViewData?

    /// Handles user interaction when tapping on a favorite item.
    ///
    /// - Parameter index: The index of the favorite item.
    func userDidTapOnFavourite(at index: Int)

    /// Updates the user's favorite model data.
    ///
    /// - Parameter data: The updated data model.
    func updateUserFavModel(data: HomeScreenListItemViewData)
}
