//
//  HomeScreenTableViewCell.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import UIKit

final class HomeScreenTableViewCell: UITableViewCell {

    // MARK: Properties
    lazy var homeScreenCellView: HomeScreenCellView = {
        let homeScreenCellView = HomeScreenCellView()
        homeScreenCellView.translatesAutoresizingMaskIntoConstraints = false
        return homeScreenCellView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init? coder not implemented")
    }

    // MARK: Setup UI and its Constraint
    private func setupUI() {
        self.contentView.addSubview(homeScreenCellView)
        homeScreenCellView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,
                                                    constant: .zero).isActive = true
        homeScreenCellView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
                                                     constant: .zero).isActive = true
        homeScreenCellView.topAnchor.constraint(equalTo: self.contentView.topAnchor,
                                                constant: .zero).isActive = true
        homeScreenCellView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,
                                                   constant: .zero).isActive = true
    }

    //MARK: SetData for label text
    func setData(data: HomeScreenListItemViewData,
                 viewModel: HomeScreenViewInputCommonProtocol)
    {
        homeScreenCellView.setData(data: data,
                                   viewModel: viewModel)
    }
}
