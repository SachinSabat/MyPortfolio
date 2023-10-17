//
//  HomeScreenTableViewCellHandler.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit.UITableView

/**
 A handler for the home screen table view cell section.

 This handler provides the logic for configuring and managing cells within the home screen table view section.

 - Note: Conforming to `TableViewSectionProtocol`, this class represents a specific section type within the table view.

 - SeeAlso: `TableViewSectionProtocol` for the protocol definition.
 - SeeAlso: `HomeScreenViewInputCommonProtocol` for the common input protocol.
 */
final class HomeScreenTableViewCellHandler: TableViewSectionProtocol {

    /// The unique identifier for the home screen table view cell section.
    var type: String {
        return TableViewCellsIds.homeScreenTableViewCell.rawValue
    }

    /**
     Returns a configured table view cell for the specified indexPath.

     - Parameters:
     - cellModel: The data source for the cell.
     - tableView: The table view requesting the cell.
     - indexPath: The index path of the cell.

     - Returns: A configured home screen table view cell.

     - Important: This method dequeues or creates a home screen table view cell, sets its data, and handles the favorite button's tag and action.
     */
    func tableView(_ cellModel: HomeScreenViewInputCommonProtocol,
                   _ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellsIds.homeScreenTableViewCell.rawValue,
                                                       for: indexPath) as? HomeScreenTableViewCell
        else {
            return tableView.dequeueReusableCell(withIdentifier: TableViewCellsIds.homeScreenTableViewCell.rawValue,
                                                 for: indexPath)
        }
        // Get data for the specified row
        guard let data = cellModel.getDataForParticularRow(indexPathforRow: indexPath.row) else {
            return cell
        }
        // Set the tag and action for the favorite button
        cell.homeScreenCellView.btnMarkAsFav.tag = indexPath.row
        // Configure the cell with the data
        cell.setData(data: data, viewModel: cellModel)
        return cell
    }

    /**
     - Important: This method delegates the request to the `getNumberOfRows()` method of the `cellModel`.
     */
    func tableView(_ cellModel: HomeScreenViewInputCommonProtocol,
                   _ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        cellModel.getNumberOfRows()
    }

}
