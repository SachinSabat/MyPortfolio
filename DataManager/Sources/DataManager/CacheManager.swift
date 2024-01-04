//
//  CacheManager.swift
//
//
//  Created by Sachin Sabat on 29/12/23.
//

import Foundation

public protocol CacheManagerProtocol {
    func writeToMemory(data: Data, forKey key: String)
    func writeToDisk(data: Data, forKey key: String)
    func write(data: Data, forKey key: String)
    func readData(forKey key:String) -> Data?
    func readDataFromDisk(forKey key: String) -> Data?
    func write<T: Encodable>(codable: T, forKey key: String) throws
    func readCodable<T: Decodable>(forKey key: String) throws -> T?
    func hasData(forKey key: String) -> Bool
    func hasDataOnDisk(forKey key: String) -> Bool
    func hasDataOnMem(forKey key: String) -> Bool
    func cachePath(forKey key: String) -> String
}

public final class CacheManager: CacheManagerProtocol {

    let cacheDirectoryPrefix = "com.myportfolio.cache."
    let cacheQueuePrefix = "com.myportfolio.queue."
    /// Life time of disk cache, in second. Default is a week
    let maxCachePeriodInSecond: TimeInterval = 60 * 60 * 24 * 7         // a week

    let cachePath: String

    let memoryCache = NSCache<AnyObject, AnyObject>()
    let cacheQueue: DispatchQueue
    let fileManager: FileManager

    /// Name of cache
    public var name: String = ""

    /// Size is allocated for disk cache, in byte. 0 mean no limit. Default is 0
    public var maxDiskCacheSize: UInt = 0

    /// Specify distinc name param, it represents folder name for disk cache
    public init(name: String, path: String? = nil) {
        self.name = name

        var cachePath = path ?? NSSearchPathForDirectoriesInDomains(.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        cachePath = (cachePath as NSString).appendingPathComponent(cacheDirectoryPrefix + name)
        self.cachePath = cachePath

        cacheQueue = DispatchQueue(label: cacheQueuePrefix + name)

        self.fileManager = FileManager()
    }
}

// MARK: - Store data
public extension CacheManager {

    /// Write data for key.
    func writeToMemory(data: Data, forKey key: String) {
        memoryCache.setObject(data as AnyObject, forKey: key as AnyObject)
    }

    func writeToDisk(data: Data, forKey key: String) {
        writeDataToDisk(data: data, key: key)
    }

    func write(data: Data, forKey key: String) {
        memoryCache.setObject(data as AnyObject, forKey: key as AnyObject)
        writeDataToDisk(data: data, key: key)
    }

    private func writeDataToDisk(data: Data, key: String) {
        print("sachin sabat data about to save")
        cacheQueue.async {
            if self.fileManager.fileExists(atPath: self.cachePath) == false {
                do {
                    print(self.cachePath)
                    try self.fileManager.createDirectory(atPath: self.cachePath, withIntermediateDirectories: true, attributes: nil)
                    print("data saved")
                } catch {
                    print("DataCache: Error while creating cache folder: \(error.localizedDescription)")
                }
            }
            self.fileManager.createFile(atPath: self.cachePath(forKey: key), contents: data, attributes: nil)
        }
    }

    /// Read data for key
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

    /// Read data from disk for key
    func readDataFromDisk(forKey key: String) -> Data? {
        return self.fileManager.contents(atPath: cachePath(forKey: key))
    }

    // MARK: - Read & write Codable types
    func write<T: Encodable>(codable: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(codable)
        write(data: data, forKey: key)
    }

    func readCodable<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = readData(forKey: key) else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
}

// MARK: - Utils

extension CacheManager {
    /// Check if has data for key
    public func hasData(forKey key: String) -> Bool {
        return hasDataOnDisk(forKey: key) || hasDataOnMem(forKey: key)
    }

    /// Check if has data on disk
    public func hasDataOnDisk(forKey key: String) -> Bool {
        return self.fileManager.fileExists(atPath: self.cachePath(forKey: key))
    }

    /// Check if has data on mem
    public func hasDataOnMem(forKey key: String) -> Bool {
        return (memoryCache.object(forKey: key as AnyObject) != nil)
    }

    public func cachePath(forKey key: String) -> String {
        let fileName = key
        return (cachePath as NSString).appendingPathComponent(fileName)
    }
}
