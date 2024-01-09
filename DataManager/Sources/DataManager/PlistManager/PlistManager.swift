//
//  PlistManager.swift
//
//
//  Created by Sachin Sabat on 30/12/23.
//

import Foundation

public struct Plist {

    public let name:String

    public var sourcePath:String? {
        guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
        return path
    }

    public var destPath:String? {
        guard sourcePath != .none else { return .none }
        let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        return (dir as NSString).appendingPathComponent("\(name).plist")
    }

    public init?(name:String) {

        self.name = name

        let fileManager = FileManager.default

        guard let source = sourcePath else {
            return nil }
        guard let destination = destPath else { return nil }
        guard fileManager.fileExists(atPath: source) else {
            return nil }

        if !fileManager.fileExists(atPath: destination) {
            do {
                try fileManager.copyItem(atPath: source, toPath: destination)
            } catch _ as NSError {
                return nil
            }
        }
    }

    public func getMutablePlistFile() -> NSMutableDictionary? {
        let fileManager = FileManager.default
        guard let destPath = destPath else { return nil }
        if fileManager.fileExists(atPath: destPath) {
            guard let dict = NSMutableDictionary(contentsOfFile: destPath) else { return .none }
            return dict
        } else {
            return .none
        }
    }

    public func addValuesToPlistFile(dictionary:NSDictionary) throws {
        let fileManager = FileManager.default
        guard let destPath = destPath else { return }
        if fileManager.fileExists(atPath: destPath) {
            if !dictionary.write(toFile: destPath, atomically: false) {
                throw PlistManagerError.fileNotWritten
            }
        } else {
            throw PlistManagerError.fileDoesNotExist
        }
    }

}

public class PlistManager: PlistManagerProtocol {

    public init() { }

    public func addNew(_ value: Any, key: String, 
                       toPlistWithName: String,
                       completion:(_ error :PlistManagerError?) -> ()) {
        if !keyAlreadyExists(key: key, inPlistWithName: toPlistWithName) {
            if let plist = Plist(name: toPlistWithName) {

                guard let dict = plist.getMutablePlistFile() else {
                    completion(.fileUnavailable)
                    return
                }
                dict[key] = value
                do {
                    try plist.addValuesToPlistFile(dictionary: dict)
                    completion(nil)
                } catch {
                    completion(error as? PlistManagerError)
                }

            } else {
                completion(.fileUnavailable)
            }
        } else {
            completion(.keyValuePairAlreadyExists)
        }
    }

    public func removeKeyValuePair(for key: String, 
                                   fromPlistWithName: String,
                                   completion:(_ error :PlistManagerError?) -> ()) {
        if keyAlreadyExists(key: key, inPlistWithName: fromPlistWithName) {
            if let plist = Plist(name: fromPlistWithName) {

                guard let dict = plist.getMutablePlistFile() else {
                    completion(.fileUnavailable)
                    return
                }
                dict.removeObject(forKey: key)
                do {
                    try plist.addValuesToPlistFile(dictionary: dict)
                    completion(nil)
                } catch {
                    completion(error as? PlistManagerError)
                }
            } else {
                completion(.fileUnavailable)
            }
        } else {
            completion(.keyValuePairDoesNotExist)
        }
    }

    public func removeAllKeyValuePairs(fromPlistWithName: String, 
                                       completion:(_ error :PlistManagerError?) -> ()) {

        if let plist = Plist(name: fromPlistWithName) {
            guard let dict = plist.getMutablePlistFile() else {
                completion(.fileUnavailable)
                return
            }
            let keys = Array(dict.allKeys)

            if keys.count != 0 {
                dict.removeAllObjects()
            } else {
                completion(.fileAlreadyEmpty)
                return
            }
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
                completion(nil)
            } catch {
                completion(error as? PlistManagerError)
            }
        } else {
            completion(.fileUnavailable)
        }
    }

    public func addNewOrSave(_ value: Any, 
                             forKey: String,
                             toPlistWithName: String,
                             completion:(_ error :PlistManagerError?) -> ()) {
        if keyAlreadyExists(key: forKey, inPlistWithName: toPlistWithName){
            save(value, forKey: forKey, toPlistWithName: toPlistWithName, completion: completion)
        }else{
            addNew(value, key: forKey, toPlistWithName: toPlistWithName, completion: completion)
        }
    }

    public func save(_ value: Any, forKey: String,
                     toPlistWithName: String,
                     completion:(_ error :PlistManagerError?) -> ()) {

        if let plist = Plist(name: toPlistWithName) {
            guard let dict = plist.getMutablePlistFile() else {
                completion(.fileUnavailable)
                return
            }
            if let _ = dict[forKey] {
                dict[forKey] = value
            }
            do {
                try plist.addValuesToPlistFile(dictionary: dict)
                completion(nil)
            } catch {
                completion(error as? PlistManagerError)
            }
        } else {
            completion(.fileUnavailable)
        }
    }

    public func fetchValue(for key: String, 
                           fromPlistWithName: String) -> Any? {

        guard let plist = Plist(name: fromPlistWithName),
              let dict = plist.getMutablePlistFile() else {
            return nil
        }

        guard let value = dict[key] else {
            return nil
        }
        return value
    }

    public func getValue(for key: String, 
                         fromPlistWithName: String,
                         completion:(_ result : Any?,
                                     _ error :PlistManagerError?) -> ()) {
        guard let plist = Plist(name: fromPlistWithName),
              let dict = plist.getMutablePlistFile() else {
            completion(nil, .fileUnavailable)
            return
        }
        guard let value = dict[key] else {
            completion(nil, .keyValuePairDoesNotExist)
            return
        }
        completion(value, nil)
    }

    public func keyAlreadyExists(key: String,
                                 inPlistWithName: String) -> Bool {
        guard let plist = Plist(name: inPlistWithName),
              let dict = plist.getMutablePlistFile() else { return false }

        let keys = dict.allKeys
        return keys.contains { $0 as? String == key }

    }
}
