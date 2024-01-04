// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Foundation
import NetworkManager

public protocol DataManagerProtocol {
    @available(iOS 13.0, *)
    func executeRequest<T: Codable, E: APIModelProtocol>(
        with endpoint: E,
        objectType: T.Type,
        requestType: RequestType
    ) -> AnyPublisher<T, NetworkError> where T: Codable, E: APIModelProtocol
}

@available(iOS 13.0, *)
public final class DataHandler: DataManagerProtocol {
    let networkClient: NetworkClientServiceProtocol?
    let plistManager: PlistManagerProtocol?
    let cacheManager: CacheManagerProtocol?

    public init(networkClient: NetworkClientServiceProtocol? = nil,
                plistManager: PlistManagerProtocol? = nil,
                cacheManager: CacheManagerProtocol? = nil) {
        self.networkClient = networkClient
        self.plistManager = plistManager
        self.cacheManager = cacheManager
    }

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

    public func executePersistentStorageType(type: PersistentStoreType) {
        switch type {
        case .COREDATA:
            break
        case .KEYCHAIN:
            break
        case .PLIST(plistData: let data):
            executePlistTasks(plistData: data)
            break
        case .REALM:
            break
        case .SQLITE:
            break
        }
    }

    public func executePlistTasks(plistData: PlistData) {
        switch plistData.plistAction {
        case .addNewValue:
            plistManager?.addNew(plistData.value,
                                 key: plistData.key,
                                 toPlistWithName: plistData.plistName) { error in

            }
        case .saveValue:
            plistManager?.save(plistData.value,
                               forKey: plistData.key,
                               toPlistWithName: plistData.plistName) { error in

            }
        default:
            plistManager?.removeAllKeyValuePairs(fromPlistWithName: plistData.plistName) { error in

            }
        }
    }

    public func executeAPIRequest<T: Codable, E: APIModelProtocol>(
        with endpoint: E,
        objectType: T.Type,
        cacheName: String
    ) -> AnyPublisher<T, NetworkError> where T: Codable, E: APIModelProtocol {
        if cacheManager?.hasData(forKey: cacheName) == true {
            if let data: Data = (cacheManager?.readData(forKey: cacheName)),
                let decode = try? JSONDecoder().decode(T.self, from: data) {
                return Just(decode)
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
            }
            return Empty<T, NetworkError>()
                .eraseToAnyPublisher()
        } else {
            return (networkClient?.request(with: endpoint,
                                           objectType: objectType)
                .map({ result in
                    self.saveToCache(result: result, 
                                     cacheName: cacheName)
                    return result
                })
                    .eraseToAnyPublisher()) ?? Empty<T, NetworkError>().eraseToAnyPublisher()
        }
    }

    func saveToCache(result: Codable, cacheName: String) {
        do {
            try self.cacheManager?.write(codable: result,
                                         forKey: cacheName)
        }
        catch {
            print("unable to save cache data")
        }
    }
}

public enum RequestType {
    case APIREQUEST(cacheName: String)
    case PERSISTENTSTORAGE(type: PersistentStoreType)
}

public enum PersistentStoreType {
    case COREDATA
    case SQLITE
    case REALM
    case PLIST(plistData: PlistData)
    case KEYCHAIN
}

public enum PlistAction {
    case addNewValue
    case saveValue
    case fetchValue
    case getValue
    case removeKeyValue
    case removeAllKeyValue
}

public struct PlistData {
    var value: Any
    var key: String
    var plistName: String
    var plistAction: PlistAction
}
