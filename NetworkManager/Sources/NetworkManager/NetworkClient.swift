//
//  NetworkClient.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
import Combine

/// A class responsible for handling network-related operations.
@available(iOS 13.0, *)
public final class NetworkClient {

    private let networkService: NetworkServiceProtocol
    /// Initializes a new `NetworkClient` instance.
    ///
    /// - Parameter networkService: The network service to be used for network operations.
    ///
    public init(
        with networkService: NetworkServiceProtocol
    ) {
        self.networkService = networkService
    }
}

/// An extension of `NetworkClient` conforming to `NetworkClientServiceProtocol`.
@available(iOS 13.0, *)
extension NetworkClient: NetworkClientServiceProtocol {

    /// Sends a network request and handles the response.
    ///
    /// - Parameters:
    ///   - endpoint: The API endpoint to request data from.
    ///   - objectType: The type of object that the response should be decoded into.
    ///   - completion: A closure that is called once the request is complete, providing a `Result` type.
    ///
    /// - Returns: A URLSessionDataTask representing the ongoing network request.
    ///
    /// - Important: This method expects the `endpoint` parameter to conform to `APIModelProtocol`.
    ///              The response is expected to be in JSON format and is decoded using `JSONResponseDecoder`.
    ///
    public func request<T, E>(
        with endpoint: E,
        objectType: T.Type
    ) -> AnyPublisher<T, NetworkError> where T: Decodable, E: APIModelProtocol
    {
        return networkService.request(endpoint: endpoint)
    }
}

@available(iOS 13.0, *)
extension NetworkClient {
    // MARK: - Private
    /// Decodes network response data into a specified type.
    ///
    /// This method is used to decode network response data into a specified type using a given `ResponseDecoder`.
    ///
    /// - Parameters:
    ///   - data: The data to be decoded.
    ///   - decoder: The decoder used for decoding the data.
    ///
    /// - Returns: A `Result` type containing either the successfully decoded result or a `NetworkError`.
    ///
    /// - Parameter T: The type into which the response data should be decoded.
    ///
    private func decode<T: Decodable>(
        data: Data?,
        decoder: ResponseDecoder
    ) -> Result<T, NetworkError> {
        do {
            guard let data = data else {
                return .failure(NetworkError.unknown)
            }
            let result: T = try decoder.decode(data)
            return .success(result)
        } catch {
            return .failure(NetworkError.unknown)
        }
    }
}
