//
//  HomeScreenViewModel.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// A view model responsible for managing the Home Screen.
final class HomeScreenViewModel: HomeScreenViewInputCommonProtocol {

    //MARK: Properties
    /// data model for home screen
    private(set) var homeScreenDataModel: HomeScreenListViewData?
    /// cell type declaration for table View
    var cellType: String = TableViewCellsIds.homeScreenTableViewCell.rawValue
    /// A weak reference to the view.
    weak var viewDelegate: HomeScreenViewModelOutput?
    /// A home screen use case
    private var homeScreenUsecase: StocksListUseCaseProtocol

    //MARK: Initializer
    init(
        homeScreenUsecase: StocksListUseCaseProtocol,
        homeScreenDataModel: HomeScreenListViewData? = nil
    ) {
        self.homeScreenUsecase = homeScreenUsecase
        self.homeScreenDataModel = homeScreenDataModel
    }

    /// Fetches data for the Home Screen from the API.
    func getHomeScreenData() {
        viewDelegate?.changeViewState(.loading)
        homeScreenUsecase.executeStocksListData { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(response):
                DispatchQueue.main.async {
                    self.updateDataForVM(data: response)
                    self.viewDelegate?.changeViewState(.content)
                }
            case let .failure(error):
                DispatchQueue.main.async {
                    self.viewDelegate?.changeViewState(.error(error.localizedDescription))
                }
            }
        }
    }

    private func updateDataForVM(data: StocksListDomainModel) {
        if let data = data.data {
            self.homeScreenDataModel = HomeScreenListViewData.init(stocksData: data)
        }
    }

    //MARK: TableView Protocol methods
    /// Returns the number of rows in the data.
    func getNumberOfRows() -> Int {
        guard let dataCount = homeScreenDataModel?.dataCount else {
            return .zero
        }
        return dataCount
    }

    /// Retrieves data for a specific row at the given index.
    func getDataForParticularRow(indexPathforRow: Int) -> HomeScreenListItemViewData? {
        guard let dataCount = homeScreenDataModel?.dataCount,
              dataCount > indexPathforRow else {
            return nil
        }
        homeScreenDataModel?.data?[indexPathforRow].atIndex = indexPathforRow
        return homeScreenDataModel?.data?[indexPathforRow]
    }

    //MARK: FooterView Calculations Func
    /// Retrieves the total current value of all data items.
    func getAllCurrentValue() -> Double {
        return homeScreenUsecase.getAllCurrentValue()
    }

    /// Retrieves the total investment value of all data items.
    func getAllInvestmentValue() -> Double {
        return homeScreenUsecase.getAllInvestmentValue()
    }

    /// Retrieves the total profit and loss value.
    func getTotalPnL() -> (Double, ProfitLossState)? {
        if let getTotalPnl = homeScreenUsecase.getTotalPnL() {
            return (getTotalPnl.0, getTotalPnl.1)
        }
        return nil
    }

    /// Retrieves today's profit and loss value.
    func getTodaysPnL() -> (Double, ProfitLossState)? {
        if let todaysPnL = homeScreenUsecase.getTodaysPnL() {
            return (todaysPnL.0, todaysPnL.1)
        }
        return nil
    }

    /// Handles the user's tap on the favorite button for a data item.
    func userDidTapOnFavourite(at index: Int) {
        guard let dataCount = homeScreenDataModel?.dataCount,
              dataCount > index else {
            return
        }
        if let isFavourite = homeScreenDataModel?.data?[index].isFavourite {
            homeScreenDataModel?.data?[index].isFavourite = !isFavourite
        }
        self.viewDelegate?.changeViewState(.reloadAtParticularRowIndex(index))
    }

    /// Updates the user's favorite data model.
    func updateUserFavModel(data: HomeScreenListItemViewData) {
        homeScreenDataModel?.data?[data.atIndex] = data
        self.viewDelegate?.changeViewState(.reloadAtParticularRowIndex(data.atIndex))
    }
}
