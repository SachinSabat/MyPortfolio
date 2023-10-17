//
//  NetworkSessionManagerMock.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

struct NetworkSessionManagerMock: NetworkSessionManagerProtocol {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?

    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> URLSessionDataTask? {
        completion(data, response, error)
        return nil
    }
}
