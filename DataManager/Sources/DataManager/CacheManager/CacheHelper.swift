//
//  CacheHelper.swift
//
//
//  Created by Sachin Sabat on 06/01/24.
//

import Foundation
import Combine
import NetworkManager

@available(iOS 13.0, *)
public struct CacheHelper: CacheHelperProtocol {
    /// The underlying cache manager handling caching operations.
    let cacheManager: CacheManagerProtocol

    /**
     Initializes a `CacheManagerWrapper` with a specified `CacheManagerProtocol`.

     - Parameter cacheManager: The cache manager used by the `CacheManagerWrapper`.
     */
    public init(cacheManager: CacheManagerProtocol) {
        self.cacheManager = cacheManager
    }
    /**
     Checks if the cache manager contains data for a specific cache.

     - Parameter cacheName: The name of the cache to check.

     - Returns: `true` if the cache manager has data for the specified cache, otherwise `false`.

     - Note: Ensure that your `CacheManager` conforms to the `CacheManagerProtocol`.
     */
    public func doesCacheManagerHasData(cacheName: String) -> Bool {
        guard cacheManager.hasData(forKey: cacheName) == true else {
            return false
        }
        return true
    }

    /**
     Reads data from the cache manager for a specific cache name.

     - Parameters:
     - objectType: The type of the object to be decoded from the cache.
     - cacheName: The name of the cache from which to read the data.

     - Returns: A publisher that emits the decoded object of the specified type from the cache, or an error of type `NetworkError` if decoding fails.

     - Note: Ensure that your `CacheManager` conforms to the `CacheManagerProtocol`.
     */
    public func readDataFromCacheManager<T: Codable>(objectType: T.Type,
                                                     cacheName: String) -> AnyPublisher<T, NetworkError> where T: Codable {
        // Attempt to read data from the cache
        if let data: Data = (cacheManager.readData(forKey: cacheName)),
           // Attempt to decode the data into the specified object type
           let decodedObject = try? JSONDecoder().decode(T.self, from: data) {
            // Return a publisher emitting the decoded object
            return Just(decodedObject)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
        // Return an empty publisher with a NetworkError if decoding or reading fails
        return Empty<T, NetworkError>()
            .eraseToAnyPublisher()
    }

    /**
     Saves a Codable object to the cache manager with a specified cache name.

     - Parameters:
     - result: The Codable object to be saved to the cache.
     - cacheName: The name of the cache where the object will be saved.

     - Note: Ensure that your `CacheManager` conforms to the `CacheManagerProtocol`.
     */
    public func saveToCache(result: Codable, cacheName: String) {
        do {
            // Attempt to write the Codable object to the cache
            try self.cacheManager.write(codable: result, forKey: cacheName)
        }
        catch {
            // Print a message if saving to the cache fails
            print("Error: Unable to save cache data. \(error.localizedDescription)")
        }
    }
}
