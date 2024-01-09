//
//  CacheManagerProtocol.swift
//
//
//  Created by Sachin Sabat on 06/01/24.
//

import Foundation
import Combine
import NetworkManager

// MARK: - Cache Manager Protocol

/// Protocol defining the required operations for a cache manager.
public protocol CacheManagerProtocol {
    /// The name of the cache.
    var name: String { get set }

    /// Write data to memory for a specific key.
    func writeToMemory(data: Data, forKey key: String)

    /// Write data to disk for a specific key.
    func writeToDisk(data: Data, forKey key: String)

    /// Write data to both memory and disk for a specific key.
    func write(data: Data, forKey key: String)

    /// Read data from cache for a specific key.
    func readData(forKey key: String) -> Data?

    /// Read data from disk for a specific key.
    func readDataFromDisk(forKey key: String) -> Data?

    /// Write Codable type to cache for a specific key.
    func write<T: Encodable>(codable: T, forKey key: String) throws

    /// Read Codable type from cache for a specific key.
    func readCodable<T: Decodable>(forKey key: String) throws -> T?

    /// Check if data is available for a specific key either in memory or on disk.
    func hasData(forKey key: String) -> Bool

    /// Check if data is available on disk for a specific key.
    func hasDataOnDisk(forKey key: String) -> Bool

    /// Check if data is available in memory for a specific key.
    func hasDataOnMem(forKey key: String) -> Bool

    /// Get the full cache path for a specific key.
    func cachePath(forKey key: String) -> String
}


@available(iOS 13.0, *)
// MARK: - Cache Helper Protocol

/// Protocol defining the required operations for a cache helper.
public protocol CacheHelperProtocol {
    /// Check if the cache manager has data for a specific cache name.
    func doesCacheManagerHasData(cacheName: String) -> Bool

    /// Read data from the cache manager for a specific object type and cache name.
    func readDataFromCacheManager<T: Codable>(objectType: T.Type,
                                              cacheName: String) -> AnyPublisher<T, NetworkError> where T: Codable

    /// Save Codable result to the cache for a specific cache name.
    func saveToCache(result: Codable, cacheName: String)
}
