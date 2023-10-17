//
//  HomeDetailScreenSnapshotTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-17.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import MyPortfolio

final class HomeDetailScreenSnapshotTest: XCTestCase {

    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    var viewModel: HomeDetailScreenViewModel!
    let loadHomeScreenListViewData = StockUtils().loadHomeScreenListViewData()

    override func setUp() {
        if let data = loadHomeScreenListViewData?.data?.first {
            viewModel = .init(data: data)
        }
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func test_HomeDetailScreen_View() {
        let viewController = returnViewController()
        let size = CGSize(width: screenWidth, height: viewController.view.bounds.height)
        assertSnapshot(of: viewController, as: .image(size: size))
        assertSnapshot(of: viewController, as: .image(on: .iPhone8(.landscape)))
    }

    private func returnViewController() -> UIViewController {
        let detailview = HomeDetailScreenView(viewModel: viewModel)
        return UIHostingController(rootView: detailview)
    }
}


