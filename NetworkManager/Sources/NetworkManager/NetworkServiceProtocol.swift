//
//  NetworkServiceProtocol.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
import Combine

/// Contains necessary methods to generate `URLRequest`
public protocol APIConfigurations {
    func getHTTPMethod() -> HTTPMethod
    func getAPIPath() -> String
    func getAPIBasePath() -> String
    func getHeaders() -> [String: String]
}

// API request model
public protocol APIModelProtocol {
    var api: APIConfigurations { get set }

    /// Post request body parameters
    var params: [String: Any]? { get set }
}

// Getting the decodable mapped JSON data
/// Types conforming to `NetworkClientServiceProtocol` are responsible for sending network requests, decoding responses, and handling results.
@available(iOS 13.0, *)
public protocol NetworkClientServiceProtocol {
    @discardableResult
    func request<T: Decodable, E: APIModelProtocol>(
        with endpoint: E,
        objectType: T.Type
    ) -> AnyPublisher<T, NetworkError>
}

// Getting the raw data from the API request
/// Types conforming to `NetworkServiceProtocol` are responsible for sending network requests and handling responses.
@available(iOS 13.0, *)
public protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: APIModelProtocol) -> AnyPublisher<T, NetworkError>
}

// Getting the data or error from the response of the API
/// Types conforming to `NetworkSessionManagerProtocol` are responsible for initiating network requests.
@available(iOS 13.0, *)
public protocol NetworkSessionManagerProtocol {
    func request(request: URLRequest) -> URLSession.DataTaskPublisher
}

// Types of HTTP methods
public enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

// Parsing and sending request from API
public enum NetworkError: Swift.Error {
    case incorrectData(Data)
    case incorrectURL
    case unknown
    case requestFailed
    case tokenExpired
    case customApiError(ApiErrorDTO)
    case emptyErrorWithStatusCode(String)
    case normalError(Error)
}

public struct ApiErrorDTO: Codable {
    let code: String?
    let message: String?
    let errorItems: [String: String]?
}
