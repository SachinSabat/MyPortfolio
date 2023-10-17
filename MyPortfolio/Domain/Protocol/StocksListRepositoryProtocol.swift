//
//  StocksListRepositoryProtocol.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//
import Foundation.NSURLSession

/**
 A protocol for fetching data related to the user stocks list.

 This protocol defines a method for fetching a list of data for the portfolio.

 - Note: Implement this protocol in a concrete class or struct to provide the actual implementation for fetching the data.
 **/
protocol StocksListRepositoryProtocol {
    /*
     Fetches the list of data for the stocks list of a user portfolio.

     Parameter completion: A closure to be called once the data fetch operation is complete.
     The closure should be called with a Result type, containing either the fetched data or an error.
     */
    @discardableResult
    func fetchStocksList(
        completion: @escaping (Result<StocksListDomainModel, NetworkError>) -> Void
    ) -> URLSessionDataTask?
}
