//
//  StockUtils.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class StockUtils {

    func loadArrStocksItemDataDomainModel() -> [StocksItemDataDomainModel]? {
        let stockslist = returnDecodableStockList()
        return stockslist.toDomain().data
    }

    func loadHomeScreenListViewData() -> HomeScreenListViewData? {
        var homeScreenDataModel: HomeScreenListViewData? = nil
        let data = loadArrStocksItemDataDomainModel()
        if let data = data {
            homeScreenDataModel = HomeScreenListViewData.init(stocksData: data)
        }
        return homeScreenDataModel
    }

    func loadStocksListDomainModel() -> StocksListDomainModel {
        let stocksModel = returnDecodableStockList()
        return stocksModel.toDomain()
    }

    private func returnDecodableStockList() -> StocksListModelDTO {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "Stocks", withExtension: "json")!
        let data = try! Data(contentsOf: fileUrl)
        return try! JSONDecoder().decode(StocksListModelDTO.self, from: data)
    }
}
