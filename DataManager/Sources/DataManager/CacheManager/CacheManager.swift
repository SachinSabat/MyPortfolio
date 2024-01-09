//
//  CacheManager.swift
//
//
//  Created by Sachin Sabat on 29/12/23.
//

import Foundation

@available(iOS 13.0, *)

/// A cache manager for handling in-memory and on-disk caching.
public final class CacheManager: CacheManagerProtocol {

    /// The unique name or identifier for the cache.
    public var name: String = ""

    /// The prefix used for cache directory.
    private let cacheDirectoryPrefix = "com.myportfolio.cache."

    /// The prefix used for cache queue.
    private let cacheQueuePrefix = "com.myportfolio.queue."

    /// Life time of disk cache, in second. Default is a week.
    private let maxCachePeriodInSecond: TimeInterval = 60 * 60 * 24 * 7  // a week

    /// The path to the cache directory.
    private let cachePath: String

    /// NSCache for in-memory caching.
    private let memoryCache = NSCache<AnyObject, AnyObject>()

    /// DispatchQueue for cache operations.
    private let cacheQueue: DispatchQueue

    /// FileManager for handling file operations.
    private let fileManager: FileManager

    /// Size allocated for disk cache, in bytes. 0 means no limit. Default is 0.
    public var maxDiskCacheSize: UInt = 0

    /// Initializes a new cache manager with a given name.
    /// - Parameter name: The unique name or identifier for the cache.
    public init(name: String) {
        self.name = name
        var cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        cachePath = (cachePath as NSString).appendingPathComponent(cacheDirectoryPrefix + name)
        self.cachePath = cachePath

        cacheQueue = DispatchQueue(label: cacheQueuePrefix + name)
        fileManager = FileManager()
    }
}

// MARK: - Store data
@available(iOS 13.0, *)
public extension CacheManager {

    // MARK: - Memory and Disk Write Operations

    /// Writes data to the memory cache for a specific key.
    /// - Parameters:
    ///   - data: The data to be stored in the memory cache.
    ///   - key: The unique key associated with the data.
    func writeToMemory(data: Data, forKey key: String) {
        memoryCache.setObject(data as AnyObject, forKey: key as AnyObject)
    }

    /// Writes data to the disk cache for a specific key.
    /// - Parameters:
    ///   - data: The data to be stored in the disk cache.
    ///   - key: The unique key associated with the data.
    func writeToDisk(data: Data, forKey key: String) {
        writeDataToDisk(data: data, key: key)
    }

    /// Writes data to both memory and disk caches for a specific key.
    /// - Parameters:
    ///   - data: The data to be stored.
    ///   - key: The unique key associated with the data.
    func write(data: Data, forKey key: String) {
        memoryCache.setObject(data as AnyObject, forKey: key as AnyObject)
        writeDataToDisk(data: data, key: key)
    }

    // MARK: - Private Disk Write Operation

    /// Writes data to the disk cache for a specific key in a background queue.
    /// - Parameters:
    ///   - data: The data to be stored in the disk cache.
    ///   - key: The unique key associated with the data.
    private func writeDataToDisk(data: Data, key: String) {
        cacheQueue.async {
            if self.fileManager.fileExists(atPath: self.cachePath) == false {
                do {
                    try self.fileManager.createDirectory(atPath: self.cachePath, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("DataCache: Error while creating cache folder: \(error.localizedDescription)")
                }
            }
            self.fileManager.createFile(atPath: self.cachePath(forKey: key), contents: data, attributes: nil)
        }
    }

    // MARK: - Read Operations

    /// Reads data from the memory cache for a specific key.
    /// - Parameter key: The unique key associated with the data.
    /// - Returns: The data associated with the key, if available in the memory cache.
    func readData(forKey key:String) -> Data? {
        var data = memoryCache.object(forKey: key as AnyObject) as? Data

        if data == nil {
            if let dataFromDisk = readDataFromDisk(forKey: key) {
                data = dataFromDisk
                memoryCache.setObject(dataFromDisk as AnyObject, forKey: key as AnyObject)
            }
        }

        return data
    }

    /// Reads data from the disk cache for a specific key.
    /// - Parameter key: The unique key associated with the data.
    /// - Returns: The data associated with the key, if available in the disk cache.
    func readDataFromDisk(forKey key: String) -> Data? {
        return self.fileManager.contents(atPath: cachePath(forKey: key))
    }

    // MARK: - Codable Read & Write Operations

    /// Writes a Codable object to both memory and disk caches for a specific key.
    /// - Parameters:
    ///   - codable: The Codable object to be stored.
    ///   - key: The unique key associated with the object.
    /// - Throws: An error if encoding or writing fails.
    func write<T: Encodable>(codable: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(codable)
        write(data: data, forKey: key)
    }

    /// Reads a Codable object from the cache for a specific key.
    /// - Parameter key: The unique key associated with the object.
    /// - Returns: The decoded Codable object, if available in the cache.
    /// - Throws: An error if decoding or reading fails.
    func readCodable<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = readData(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Utils

@available(iOS 13.0, *)
extension CacheManager {
    // MARK: - Cache Check Operations

    /// Checks if data is available for a specific key either in memory or on disk.
    /// - Parameter key: The unique key associated with the data.
    /// - Returns: `true` if data is available; otherwise, `false`.
    public func hasData(forKey key: String) -> Bool {
        return hasDataOnDisk(forKey: key) || hasDataOnMem(forKey: key)
    }

    /// Checks if data is available on disk for a specific key.
    /// - Parameter key: The unique key associated with the data.
    /// - Returns: `true` if data is available on disk; otherwise, `false`.
    public func hasDataOnDisk(forKey key: String) -> Bool {
        return self.fileManager.fileExists(atPath: self.cachePath(forKey: key))
    }

    /// Checks if data is available in memory for a specific key.
    /// - Parameter key: The unique key associated with the data.
    /// - Returns: `true` if data is available in memory; otherwise, `false`.
    public func hasDataOnMem(forKey key: String) -> Bool {
        return (memoryCache.object(forKey: key as AnyObject) != nil)
    }

    /// Returns the full cache path for a specific key.
    /// - Parameter key: The unique key associated with the data.
    /// - Returns: The full cache path.
    public func cachePath(forKey key: String) -> String {
        let fileName = key
        return (cachePath as NSString).appendingPathComponent(fileName)
    }
}
