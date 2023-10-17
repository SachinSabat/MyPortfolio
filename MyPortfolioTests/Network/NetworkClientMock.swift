//
//  NetworkClientMock.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
import Foundation
import UIKit
@testable import MyPortfolio

final class NetworkClientMock: NetworkServiceProtocol {

    func request(endpoint: APIModelProtocol, completion: @escaping CompletionHandler) -> URLSessionDataTask? {

        if case StocksAPI.getStocksList = .getStocksList {
            let bundle = Bundle(for: type(of: self))
            let fileUrl = bundle.url(forResource: "Stocks", withExtension: "json")!
            let data = try! Data(contentsOf: fileUrl)
            completion(Result.success(data))
        }  else {
            completion(Result.failure(.incorrectURL))
        }

        return nil
    }
}

final class NetworkClientServiceMock: NetworkClientServiceProtocol {


    func request<T, E>(with endpoint: E, objectType: T.Type, completion: @escaping CompletionHandler<T>) -> URLSessionDataTask? where T : Decodable, E : APIModelProtocol {
        if case StocksAPI.getStocksList = .getStocksList {
            let bundle = Bundle(for: type(of: self))
            let fileUrl = bundle.url(forResource: "Stocks", withExtension: "json")!
            let data = try! Data(contentsOf: fileUrl)
            let json = try! JSONDecoder().decode(T.self, from: data)
            completion(Result.success(json))
        }  else {
            completion(Result.failure(.incorrectURL))
        }
        return nil
    }

}

