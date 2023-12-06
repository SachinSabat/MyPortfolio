//
//  NetworkJsonDecoder.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

/// A protocol for defining response data decoders.
///
/// Types conforming to `ResponseDecoder` are responsible for decoding response data into a specific type conforming to `Decodable`.
protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

// MARK: - Response Decoders
/// A response decoder for decoding JSON data into Swift objects.
final class JSONResponseDecoder: ResponseDecoder {
    /// The JSON decoder responsible for decoding JSON data.
    private let jsonDecoder = JSONDecoder()
    /// Initializes a new `JSONResponseDecoder` instance.
    init() { }
    // Decodes JSON response data into a specified type.
    ///
    /// - Parameters:
    ///   - data: The JSON data to be decoded.
    ///
    /// - Returns: The decoded object of the specified type.
    ///
    /// - Throws: An error if decoding fails.
    /// - Parameter T: The type into which the JSON data should be decoded.
    ///
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
