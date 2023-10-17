//
//  NetworkServiceProtocol.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// Contains necessary methods to generate `URLRequest`
protocol APIConfigurations {
    func getHTTPMethod() -> HTTPMethod
    func getAPIPath() -> String
    func getAPIBasePath() -> String
    func getHeaders() -> [String: String]
}

// API request model
protocol APIModelProtocol {
    var api: APIConfigurations { get set }

    /// Post request body parameters
    var params: [String: Any]? { get set }
}

// Getting the decodable mapped JSON data
/// Types conforming to `NetworkClientServiceProtocol` are responsible for sending network requests, decoding responses, and handling results.
protocol NetworkClientServiceProtocol {
    typealias CompletionHandler<T> = (Result<T, NetworkError>) -> Void

    @discardableResult
    func request<T: Decodable, E: APIModelProtocol>(
        with endpoint: E,
        objectType: T.Type,
        completion: @escaping CompletionHandler<T>
    ) -> URLSessionDataTask?
}

// Getting the raw data from the API request
/// Types conforming to `NetworkServiceProtocol` are responsible for sending network requests and handling responses.
protocol NetworkServiceProtocol {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    @discardableResult
    func request(endpoint: APIModelProtocol, completion: @escaping CompletionHandler) -> URLSessionDataTask?
}

// Getting the data or error from the response of the API
/// Types conforming to `NetworkSessionManagerProtocol` are responsible for initiating network requests.
protocol NetworkSessionManagerProtocol {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void
    @discardableResult
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler
    ) -> URLSessionDataTask?
}

// Types of HTTP methods
enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}

// Parsing and sending request from API
enum NetworkError: Swift.Error {
    case incorrectData(Data)
    case incorrectURL
    case unknown
}
