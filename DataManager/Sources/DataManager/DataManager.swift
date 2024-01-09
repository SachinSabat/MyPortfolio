// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Foundation
import NetworkManager

@available(iOS 13.0, *)
// MARK: - Data Manager

/// Final class responsible for managing data operations.
public final class DataManager: DataManagerProtocol {
    let networkClient: NetworkClientServiceProtocol?
    let plistManager: PlistManagerProtocol?
    let cacheHelper: CacheHelperProtocol?

    /// Initializer for Data Manager.
    /// - Parameters:
    ///   - networkClient: The network client service for making API requests.
    ///   - plistManager: The plist manager for handling plist-related operations.
    ///   - cacheHelper: The cache helper for managing caching of data.
    public init(networkClient: NetworkClientServiceProtocol? = nil,
                plistManager: PlistManagerProtocol? = nil,
                cacheHelper: CacheHelperProtocol? = nil) {
        self.networkClient = networkClient
        self.plistManager = plistManager
        self.cacheHelper = cacheHelper
    }

    /// Executes a data request based on the specified request type.
    /// - Parameters:
    ///   - endpoint: The API endpoint model.
    ///   - objectType: The type of Codable object expected in the response.
    ///   - requestType: The type of data request (API request or persistent storage).
    /// - Returns: A publisher emitting the result of the data request.
    public func executeRequest<T: Codable, E: APIModelProtocol>(
        with endpoint: E,
        objectType: T.Type,
        requestType: RequestType
    ) -> AnyPublisher<T, NetworkError> where T: Codable, E: APIModelProtocol {
        switch requestType {
        case .APIREQUEST(cacheName: let cacheName):
            return executeAPIRequest(with: endpoint,
                                     objectType: objectType,
                                     cacheName: cacheName)
            .eraseToAnyPublisher()
        case .PERSISTENTSTORAGE(let type):
            executePersistentStorageType(type: type)
        }
        return Empty<T, NetworkError>()
            .eraseToAnyPublisher()
    }
}

@available(iOS 13.0, *)
// MARK: - Data Manager Extension

/// Extension for executing API requests within the Data Manager.
extension DataManager {

    /// Executes an API request, either fetching from cache or making a network request.
    /// - Parameters:
    ///   - endpoint: The API endpoint model.
    ///   - objectType: The type of Codable object expected in the response.
    ///   - cacheName: The name of the cache to check for existing data.
    /// - Returns: A publisher emitting the result of the API request.
    public func executeAPIRequest<T: Codable, E: APIModelProtocol>(
        with endpoint: E,
        objectType: T.Type,
        cacheName: String
    ) -> AnyPublisher<T, NetworkError> where T: Codable, E: APIModelProtocol {
        if let hasData = cacheHelper?.doesCacheManagerHasData(cacheName: cacheName),
           hasData == true {
            guard let result = cacheHelper?.readDataFromCacheManager(objectType: objectType,
                                                                     cacheName: cacheName) else {
                return Empty<T, NetworkError>()
                    .eraseToAnyPublisher()
            }
            return result
        } else {
            return (networkClient?.request(with: endpoint,
                                           objectType: objectType)
                .map({ result in
                    /// Save data to cache
                    self.cacheHelper?.saveToCache(result: result, cacheName: cacheName)
                    return result
                })
                    .eraseToAnyPublisher()) ?? Empty<T, NetworkError>().eraseToAnyPublisher()
        }
    }
}

@available(iOS 13.0, *)
// MARK: - Data Manager Extension

/// Extension for executing persistent storage tasks within the Data Manager.
extension DataManager {

    /// Executes tasks based on the specified persistent storage type.
    /// - Parameter type: The type of persistent storage.
    public func executePersistentStorageType(type: PersistentStoreType) {
        switch type {
        case .COREDATA:
            // Implement Core Data tasks
            break
        case .KEYCHAIN:
            // Implement Keychain tasks
            break
        case .PLIST(plistData: let data):
            executePlistTasks(plistData: data)
            break
        case .REALM:
            // Implement Realm tasks
            break
        case .SQLITE:
            // Implement SQLite tasks
            break
        }
    }

    /// Executes tasks based on the provided PlistData.
    /// - Parameter plistData: The data required for plist-related tasks.
    public func executePlistTasks(plistData: PlistData) {
        switch plistData.plistAction {
        case .addNewValue:
            plistManager?.addNew(plistData.value,
                                 key: plistData.key,
                                 toPlistWithName: plistData.plistName) { error in
                // Handle completion or errors
            }
        case .saveValue:
            plistManager?.save(plistData.value,
                               forKey: plistData.key,
                               toPlistWithName: plistData.plistName) { error in
                // Handle completion or errors
            }
        default:
            plistManager?.removeAllKeyValuePairs(fromPlistWithName: plistData.plistName) { error in
                // Handle completion or errors
            }
        }
    }
}

