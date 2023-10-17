//
//  StocksAPIMocks.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

class StocksAPIMocks: APIConfigurations {
    var httpMethodType: HTTPMethod

    init(httpMethodType: HTTPMethod) {
        self.httpMethodType = httpMethodType
    }

    func getHTTPMethod() -> HTTPMethod {
        httpMethodType
    }

    func getAPIPath() -> String {
        let homeScreen = "/v3/6d0ad460-f600-47a7-b973-4a779ebbaeaf"
        return getAPIBasePath() + homeScreen
    }

    func getAPIBasePath() -> String {
        return "https://run.mocky.io"
    }

    func getHeaders() -> [String : String] {
        [:]
    }

}
