//
//  NetworkingTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class NetworkingTest: XCTestCase {
    var network: NetworkServiceProtocol!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        network = NetworkClientMock()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        network = nil
    }

    func testNetworkDataRequest() {
        let model = APIRequestModel(api: StocksAPI.getStocksList)
        network.request(endpoint: model as APIModelProtocol, completion: { (result) in
            switch result {
            case let .success(data):
                XCTAssertNotNil(data)
            case .failure:
                break
            }
        })
    }
}

