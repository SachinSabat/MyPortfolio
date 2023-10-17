//
//  HomeScreenTableViewController.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

final class HomeScreenTableViewController: UITableViewController {

    /// The view model for the home table view screen.
    private let viewModel: HomeScreenViewInputCommonProtocol?
    /// The coordinator for the home screen's detail flow.
    private let homeScreenDetailCoordinator: HomeDetailScreenFlow?
    /// The property which defines the table view cell type
    private(set) var tableViewHandler: TableViewSectionProtocol

    /// init which takes sectionHandler
    init(tableViewHandler: TableViewSectionProtocol,
         viewModel: HomeScreenViewInputCommonProtocol? = nil,
         homeScreenDetailCoordinator: HomeDetailScreenFlow? = nil) {
        self.tableViewHandler = tableViewHandler
        self.viewModel = viewModel
        self.homeScreenDetailCoordinator = homeScreenDetailCoordinator
        super.init(style: .plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: - Private
    private func setupViews() {
        tableView.register(HomeScreenTableViewCell.self,
                           forCellReuseIdentifier: TableViewCellsIds.homeScreenTableViewCell.rawValue)
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .lightGray
    }

    /// Reloads the tableView
    func reload() {
        tableView.reloadData()
    }

    /// Reloads the tableView of a particular row
    func reloadDataAtIndex(atIndex: Int) {
        guard let viewModel = viewModel,
                viewModel.getNumberOfRows() > atIndex else {
            return
        }
        let indexPath = IndexPath(item: atIndex, section: .zero)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

}

// MARK: - UITableViewDataSource Extension

extension HomeScreenTableViewController {

    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return .zero
        }
        return tableViewHandler.tableView(viewModel, tableView,
                                          numberOfRowsInSection: section)
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            return UITableViewCell()
        }
        return tableViewHandler.tableView(viewModel,
                                          tableView,
                                          cellForRowAt: indexPath)
    }
}
// MARK: - UITableViewDelegate Extension
extension HomeScreenTableViewController {
    /// didSelectRowAt delegate to present detail screen with its particular data
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel,
        let data = viewModel.getDataForParticularRow(indexPathforRow: indexPath.row) else {
            return
        }
        homeScreenDetailCoordinator?.coordinateToDetailScreen(data: data,
                                                              delegate: self)
    }
}

//MARK: Delegate Method on Click of Fav Button in Detail page
extension HomeScreenTableViewController: UpdateFavouriteDelegate {
    func userTappedOnFavouriteButton(data: HomeScreenListItemViewData) {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.updateUserFavModel(data: data)
    }
}
