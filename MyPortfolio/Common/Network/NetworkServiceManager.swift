//
//  NetworkServiceManager.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
import Combine

final class NetworkService {

    /// The session manager used for network requests.
    private let sessionManager: NetworkSessionManagerProtocol

    /// The default `URLSession` for network requests with custom configuration settings.
    static var currentSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        return URLSession(configuration: configuration)
    }()

    /// Initializes a new `NetworkService` instance.
    ///
    /// - Parameter sessionManager: The session manager to use for network requests.
    init(
        sessionManager: NetworkSessionManagerProtocol = NetworkSessionManager(currentSession: NetworkService.currentSession)
    ) {
        self.sessionManager = sessionManager
    }

    /// Performs a network request and handles the response.
    ///
    /// - Parameters:
    ///   - request: The URL request to be sent.
    ///   - completion: A closure that is called once the request is complete, providing a `Result` type containing either the response data or a `NetworkError`.
    ///
    /// - Returns: A URLSessionDataTask representing the ongoing network request.
    ///
    private func request<T: Decodable>(
        request: URLRequest
    ) -> AnyPublisher<T, Error> {
        return sessionManager.request(request: request)
            .tryMap { result in
                guard let response = result.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                return result.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

/// An extension of `NetworkService` conforming to `NetworkServiceProtocol` and `URLRequestConvertible`.
extension NetworkService: NetworkServiceProtocol, URLRequestConvertible {
    /// Sends a network request based on an API endPoints.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint defining the request details.
    ///   - completion: A closure that is called once the request is complete, providing a `Result` type containing either the response data or a `NetworkError`.
    ///
    /// - Returns: A URLSessionDataTask representing the ongoing network request.
    ///
    func request<T: Decodable>(endpoint: APIModelProtocol) -> AnyPublisher<T, Error> {
        let urlRequest = makeURLRequest(apiModel: endpoint)
        return request(request: urlRequest)
    }
}

/// A class responsible for managing network sessions using the default URLSession.
final class NetworkSessionManager: NetworkSessionManagerProtocol {

    /// The current URLSession used for network requests.
    let currentSession: URLSession

    /// Initializes a new `NetworkSessionManager` instance.
    ///
    /// - Parameter currentSession: The URLSession to be used for network requests.
    init(currentSession: URLSession) {
        self.currentSession = currentSession
    }
    /// Initiates a network request using a provided URLRequest.
    ///
    /// - Parameters:
    ///   - request: The URLRequest to be used for the network request.
    ///   - completion: A closure that is called once the request is complete, providing a `Result` type containing either the response data or a `NetworkError`.
    ///
    /// - Returns: A URLSessionDataTask representing the ongoing network request.
    ///
    func request(
        request: URLRequest) -> URLSession.DataTaskPublisher {
        let task = currentSession.dataTaskPublisher(for: request)
        return task
    }
}

