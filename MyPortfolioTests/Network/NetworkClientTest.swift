//
//  NetworkClientTest.swift
//  MyPortfolioTests
//
//  Created by Sachin Sabat on 2023-10-10.
//

import XCTest
@testable import MyPortfolio

private struct MockModel: Decodable {
    let symbol: String
}

final class NetworkClientTest: XCTestCase {

    func test_valid_Response_when_recieved() {
        /// Given
        let config = StocksAPIMocks(httpMethodType: .GET)
        var completionCallsCount = 0

        let responseData = #"{"symbol": "IRFC"}"#.data(using: .utf8)
        let networkService = NetworkService(
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: responseData,
                error: nil
            )
        )

        let networkClient = NetworkClient(with: networkService)
        /// When
        _ = networkClient.request(with: APIRequestModel(api: config), objectType: MockModel.self)
        { result in

            do {
                let object = try result.get()
                XCTAssertEqual(object.symbol, "IRFC")
                completionCallsCount += 1
            } catch {
                XCTFail("Failed decoding MockObject")
            }
        }
        /// Then
        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_when_invalid_response() {
        /// Given
        let config = StocksAPIMocks(httpMethodType: .GET)
        var completionCallsCount = 0

        let responseData = #"{"invalid": 45}"#.data(using: .utf8)
        let networkService = NetworkService(
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: responseData,
                error: nil
            )
        )

        let networkClient = NetworkClient(with: networkService)
        /// When
        _ = networkClient.request(with: APIRequestModel(api: config), objectType: MockModel.self)
        { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                completionCallsCount += 1
            }
        }
        /// Then
        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_when_no_data_received() {
        /// Given
        let config = StocksAPIMocks(httpMethodType: .GET)
        var completionCallsCount = 0

        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkService = NetworkService(
            sessionManager: NetworkSessionManagerMock(
                response: response,
                data: nil,
                error: NetworkError.incorrectData(Data())
            )
        )

        let networkClient = NetworkClient(with: networkService)
        /// When
        _ = networkClient.request(with: APIRequestModel(api: config),
                        objectType: MockModel.self)
        { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.incorrectData(Data()) = error {
                    completionCallsCount += 1
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        /// Then
        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_when_bad_request_recieved() {
        /// Given
        let config = StocksAPIMocks(httpMethodType: .GET)
        var completionCallsCount = 0

        let responseData = #"{"invalid": "none"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 501,
                                       httpVersion: "1.1",
                                       headerFields: nil)
        let networkService = NetworkService(
            sessionManager: NetworkSessionManagerMock(
                response: response,
                data: responseData,
                error: NetworkError.unknown
            )
        )

        let networkClient = NetworkClient(with: networkService)
        /// When
        _ = networkClient.request(with: APIRequestModel(api: config),
                        objectType: MockModel.self)
        { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                completionCallsCount += 1
            }
        }
        /// Then
        XCTAssertEqual(completionCallsCount, 1)
    }

    func test_when_post_method_called() {
        /// Given
        let config = StocksAPIMocks(httpMethodType: .POST)
        var completionCallsCount = 0

        let responseData = #"{"invalid": "none"}"#.data(using: .utf8)!
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 501,
                                       httpVersion: "1.1",
                                       headerFields: nil)
        let networkService = NetworkService(
            sessionManager: NetworkSessionManagerMock(
                response: response,
                data: responseData,
                error: NetworkError.unknown
            )
        )

        let networkClient = NetworkClient(with: networkService)
        /// When
        _ = networkClient.request(with: APIRequestModel(api: config,
                                                        parameters: ["stocks": "IRFC"]),
                        objectType: MockModel.self)
        { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                completionCallsCount += 1
            }
        }
        /// Then
        XCTAssertEqual(completionCallsCount, 1)
    }

}
