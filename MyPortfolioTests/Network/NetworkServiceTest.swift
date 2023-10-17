//
//  NetworkServiceTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

final class NetworkServiceTest: XCTestCase {

    func test_whenMockDataPassed_shouldReturnProperResponse() {
        /// Given
        let config = StocksAPIMocks(httpMethodType: .GET)
        var completionCallsCount = 0

        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = NetworkService(
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: expectedResponseData,
                error: nil
            )
        )
        /// When
        _ = sut.request(endpoint: APIRequestModel(api: config)) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should return proper response")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            completionCallsCount += 1
        }
        /// Then
        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_when_unknown_error_thrown() {
        /// Given
        let config = StocksAPIMocks(httpMethodType: .GET)
        var completionCallsCount = 0

        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let sut = NetworkService(
            sessionManager: NetworkSessionManagerMock(response: nil,
                                                    data: nil,
                                                error: cancelledError as Error))

        /// When
        _ = sut.request(endpoint: APIRequestModel(api: config)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.unknown = error else {
                    XCTFail("NetworkError.cancelled not found")
                    return
                }

                completionCallsCount += 1
            }
        }
        /// Then
        XCTAssertEqual(completionCallsCount, 1)
    }
}
