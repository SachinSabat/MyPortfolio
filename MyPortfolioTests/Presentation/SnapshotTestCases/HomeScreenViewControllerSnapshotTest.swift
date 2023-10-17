//
//  HomeScreenViewControllerSnapshotTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-17.
//

import XCTest
import SnapshotTesting
@testable import MyPortfolio

final class HomeScreenViewControllerSnapshotTest: XCTestCase {

    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    var network: NetworkClientServiceProtocol!
    var useCase: StocksListUseCase!
    var repository: StocksListRepository!
    var viewModel: HomeScreenViewModel!
    var loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()
    let loadArrStocksItemDataDomainModel  = StockUtils().loadArrStocksItemDataDomainModel()

    override func setUp() {
        network = NetworkClientServiceMock()
        repository = .init(networkClient: network!)
        useCase = .init(stocksListRepository: repository, stocksListDataModel: loadArrStocksItemDataDomainModel)
        viewModel = .init(homeScreenUsecase: useCase, homeScreenDataModel: loadHomeScreenListViewData)
    }

    override func tearDown() {
        viewModel = nil
        useCase = nil
        repository = nil
        network = nil
        super.tearDown()
    }

    func test_HomeScreenTableViewController_View() {
        let homeScreenTableViewCellHandler = HomeScreenTableViewCellHandler()
        let tableViewSectionCells: TableViewSectionProtocol = TableViewSectionContainer(tableViewHandler: [homeScreenTableViewCellHandler])
        let viewController = HomeScreenTableViewController(tableViewHandler: tableViewSectionCells, 
                                                           viewModel: viewModel,
                                                           homeScreenDetailCoordinator: self)
        let size = CGSize(width: screenWidth, height: 500.0)
        assertSnapshot(of: viewController, as: .image(size: size))
    }

    func test_HomeScreenTableViewController_WithOneFavTapped_View() {
        let homeScreenTableViewCellHandler = HomeScreenTableViewCellHandler()
        let tableViewSectionCells: TableViewSectionProtocol = TableViewSectionContainer(tableViewHandler: [homeScreenTableViewCellHandler])
        loadHomeScreenListViewData?.data?[0].isFavourite = true
        viewModel = .init(homeScreenUsecase: useCase, homeScreenDataModel: loadHomeScreenListViewData)
        let viewController = HomeScreenTableViewController(tableViewHandler: tableViewSectionCells,
                                                           viewModel: viewModel,
                                                           homeScreenDetailCoordinator: self)
        let size = CGSize(width: screenWidth, height: 500.0)
        assertSnapshot(of: viewController, as: .image(size: size))
    }


    func test_HomeScreenCellView_View() {
        let size = CGSize(width: screenWidth, height: 100.0)
        let view = HomeScreenCellView(frame: CGRect(origin: .zero, size: size))
        if let data = loadHomeScreenListViewData?.data?.first {
            view.setData(data: data,
                         viewModel: viewModel)
            assertSnapshot(of: view, as: .image(size: size))
        }
    }

    func test_HomeScreenCellView_Fav_Btn_Selected() {
        let size = CGSize(width: screenWidth, height: 100.0)
        let view = HomeScreenCellView(frame: CGRect(origin: .zero, size: size))
        if var data = loadHomeScreenListViewData?.data?.first {
            data.isFavourite = true
            view.setData(data: data,
                         viewModel: viewModel)
            assertSnapshot(of: view, as: .image(size: size))
        }
    }

    func test_FooterView_View() {
        let size = CGSize(width: screenWidth, height: 250.0)
        let view = FooterView(frame: CGRect(origin: .zero, size: size))
        view.setUpFooterData(viewModel: viewModel)
        assertSnapshot(of: view, as: .image(size: size))
    }

}

extension HomeScreenViewControllerSnapshotTest: HomeDetailScreenFlow {
    func coordinateToDetailScreen(data: MyPortfolio.HomeScreenListItemViewData, 
                                  delegate: MyPortfolio.UpdateFavouriteDelegate) {

    }
}
