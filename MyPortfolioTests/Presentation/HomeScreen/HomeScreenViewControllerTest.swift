//
//  HomeScreenViewControllerTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class HomeScreenViewControllerTest: XCTestCase {

    var viewModel: HomeScreenViewInputCommonProtocol!
    var viewState: ViewState = .none
    var network: NetworkClientServiceProtocol!
    let loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()
    var viewController: HomeScreenViewController!
    var viewModelTest = HomeScreenViewModelTest()
    var useCase: StocksListUseCase!
    var repository: StocksListRepository!

    override func setUp() {
        network = NetworkClientServiceMock()
        repository = .init(networkClient: network!)
        useCase = .init(stocksListRepository: repository)
        viewModel = HomeScreenViewModel(homeScreenUsecase: useCase, homeScreenDataModel: loadHomeScreenListViewData)
        let tableViewCells: TableViewSectionProtocol = TableViewSectionContainer(tableViewHandler: [HomeScreenTableViewCellHandler()])

        viewController = .init(viewModel: viewModel, homeScreenTableViewController: HomeScreenTableViewController(tableViewHandler: tableViewCells), homeScreenDetailCoordinator: self)
        viewModelTest.view = self

        viewModel.getHomeScreenData()
    }

    override func tearDown() {
        viewController = nil
        viewModel = nil
        useCase = nil
        repository = nil
        super.tearDown()
    }

    func test_getNumberOfRows_not_empty() {
        XCTAssertEqual(viewModel.getNumberOfRows(), 4)
    }

    func test_view_state_when_called_getHomeScreenData_mock() {
        viewModelTest.getHomeScreenData()
        XCTAssertEqual(viewState, .content)
    }

    func test_view_state_on_userDidTapOnFavourite_mock() {
        viewModelTest.userDidTapOnFavourite(at: 1)
        XCTAssertEqual(viewState, .reloadAtParticularRowIndex(1))
    }

    func test_for_changeviewstate_reloadAt() {
        viewController.changeViewState(.reloadAtParticularRowIndex(1))
        XCTAssertEqual(viewController.viewState, .reloadAtParticularRowIndex(1))
    }

    func test_for_changeviewstate_none() {
        viewController.changeViewState(.none)
        XCTAssertEqual(viewController.viewState, .none)
    }

    func test_view_state_when_called_updateUserFavModel_mock() {
        if let data = viewModel.getDataForParticularRow(indexPathforRow: 1) {
            viewModelTest.updateUserFavModel(data: data)
            XCTAssertEqual(viewState, .reloadAtParticularRowIndex(1))
        }
    }
}

extension HomeScreenViewControllerTest: HomeScreenViewModelOutput, HomeDetailScreenFlow {
    func updateData() {

    }

    func changeViewState(_ state: ViewState) {
        viewState = state
    }

    func coordinateToDetailScreen(data: HomeScreenListItemViewData, delegate: UpdateFavouriteDelegate) {

    }
}

final class HomeScreenViewModelTest {
    var view: HomeScreenViewModelOutput?

    func getHomeScreenData() {
        view?.changeViewState(.content)
    }

    func userDidTapOnFavourite(at index: Int) {
        view?.changeViewState(.reloadAtParticularRowIndex(index))
    }

    func updateUserFavModel(data: HomeScreenListItemViewData) {
        view?.changeViewState(.reloadAtParticularRowIndex(data.atIndex))
    }

}
