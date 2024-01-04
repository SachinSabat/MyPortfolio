//
//  StocksListModelDTO.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

// MARK: - Data Transfer Object
/// A data model representing the data for the stocks list.
struct StocksListModelDTO: Codable {
    /// An array of `StockItemDataModelDTO` objects containing stocks list data.
    let data: [StockItemDataModelDTO]
}

/// A data model representing individual data items for the stocks list .
struct StockItemDataModelDTO : Codable {
    let quantity: Double?
    let symbol: String?
    let ltp: Double?
    let avg_price: String?
    let previous_close: Double?

    enum CodingKeys: String, CodingKey {
        case quantity , symbol, ltp, avg_price, previous_close
    }

    //MARK:- init to set value for current, investment and profit and loss
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        quantity = try container.decode(Double.self, forKey: .quantity)
        symbol = try container.decode(String.self, forKey: .symbol)
        ltp = try container.decode(Double.self, forKey: .ltp)
        avg_price = try container.decode(String.self, forKey: .avg_price)
        previous_close = try container.decode(Double.self, forKey: .previous_close)
    }
}

// MARK: - Mappings to Domain
extension StocksListModelDTO {
    func toDomain() -> StocksListDomainModel {
        return .init(
            data: data.map({ data in
                data.toDomainModel()
            }))
    }
}

extension StockItemDataModelDTO {
    func toDomainModel() -> StocksItemDataDomainModel {
        return .init(quantity: quantity,
                     symbol: symbol,
                     ltp: ltp,
                     avg_price: avg_price,
                     previous_close: previous_close
        )
    }
}
