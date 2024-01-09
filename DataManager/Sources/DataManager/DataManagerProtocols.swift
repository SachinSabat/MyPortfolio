//
//  DataManagerProtocols.swift
//
//
//  Created by Sachin Sabat on 05/01/24.
//

import Foundation
import NetworkManager
import Combine

// MARK: - DataManager Protocol

/// Protocol defining data management operations.
public protocol DataManagerProtocol {
    /// Executes a request for fetching data.
    /// - Parameters:
    ///   - endpoint: The API endpoint to fetch data from.
    ///   - objectType: The type of object to decode data into.
    ///   - requestType: The type of request, either API or persistent storage.
    /// - Returns: A publisher emitting the fetched data or an error.
    @available(iOS 13.0, *)
    func executeRequest<T: Codable, E: APIModelProtocol>(
        with endpoint: E,
        objectType: T.Type,
        requestType: RequestType
    ) -> AnyPublisher<T, NetworkError> where T: Codable, E: APIModelProtocol
}

/// Enum defining types of requests in DataManager.
public enum RequestType {
    /// API request with caching option.
    case APIREQUEST(cacheName: String)
    /// Persistent storage request with specified type.
    case PERSISTENTSTORAGE(type: PersistentStoreType)
}

/// Enum defining types of persistent storage in DataManager.
public enum PersistentStoreType {
    /// Core Data persistent storage.
    case COREDATA
    /// SQLite persistent storage.
    case SQLITE
    /// Realm persistent storage.
    case REALM
    /// Plist persistent storage with associated data.
    case PLIST(plistData: PlistData)
    /// Keychain persistent storage.
    case KEYCHAIN
}


