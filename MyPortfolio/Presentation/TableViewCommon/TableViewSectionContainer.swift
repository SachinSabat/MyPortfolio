//
//  TableViewSectionContainer.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit.UITableView

protocol TableViewSectionProtocol {
    /// A unique identifier for the section type.
    var type: String { get }
    /**
     Returns a table view cell for the specified indexPath.

     - Parameters:
     - cellModel: The data source for the cell.
     - tableView: The table view requesting the cell.
     - indexPath: The index path of the cell.

     - Returns: A configured table view cell.
     */
    func tableView(_ cellModel: HomeScreenViewInputCommonProtocol,
                   _ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    /**
     Returns the number of rows in the section.

     - Parameters:
     - cellModel: The data source for the section.
     - tableView: The table view containing the section.
     - section: The section index.

     - Returns: The number of rows in the section.
     */
    func tableView(_ cellModel: HomeScreenViewInputCommonProtocol,
                   _ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int
}

final class TableViewSectionContainer: TableViewSectionProtocol {
    var type: String = ""

    /// A dictionary to store and manage `TableViewSectionProtocol` objects by their type.
    var tableViewSectionHandler: [String: TableViewSectionProtocol] = [:]
    /**
     Initializes the `TableViewSectionContainer` with an array of `TableViewSectionProtocol` objects.

     - Parameter tableViewHandler: An array of `TableViewSectionProtocol` objects to be managed by the container.

     - Note: The `type` property of each handler is used as the key in the container's dictionary.
     */
    init(tableViewHandler: [TableViewSectionProtocol]) {
        tableViewHandler.forEach { handler in
            tableViewSectionHandler[handler.type] = handler
        }
    }
    /**
     - Important: This method delegates the request to the registered section handler based on `cellModel.cellType`.
     */
    func tableView(_ cellModel: HomeScreenViewInputCommonProtocol,
                   _ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionHandler = tableViewSectionHandler[cellModel.cellType] else {
            return UITableViewCell()
        }
        return sectionHandler.tableView(cellModel,
                                        tableView,
                                        cellForRowAt: indexPath)
    }

    /**
     - Important: This method delegates the request to the registered section handler based on `cellModel.cellType`.
     */
    func tableView(_ cellModel: HomeScreenViewInputCommonProtocol,
                   _ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let sectionHandler = tableViewSectionHandler[cellModel.cellType] else {
            return .zero
        }
        return sectionHandler.tableView(cellModel,
                                        tableView,
                                        numberOfRowsInSection: section)
    }
}
