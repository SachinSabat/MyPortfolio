//
//  PlistProtocols.swift
//
//
//  Created by Sachin Sabat on 12/01/24.
//

import Foundation

// MARK: - Plist Manager Protocol

/// Protocol defining methods for plist management.
public protocol PlistManagerProtocol {
    func addNew(_ value: Any, key: String, toPlistWithName: String, completion:(_ error :PlistManagerError?) -> ())
    func removeKeyValuePair(for key: String, fromPlistWithName: String, completion:(_ error :PlistManagerError?) -> ())
    func removeAllKeyValuePairs(fromPlistWithName: String, completion:(_ error :PlistManagerError?) -> ())
    func addNewOrSave(_ value: Any, forKey: String, toPlistWithName: String, completion:(_ error :PlistManagerError?) -> ())
    func save(_ value: Any, forKey: String, toPlistWithName: String, completion:(_ error :PlistManagerError?) -> ())
    func fetchValue(for key: String, fromPlistWithName: String) -> Any?
    func getValue(for key: String, fromPlistWithName: String, completion:(_ result : Any?, _ error :PlistManagerError?) -> ())
    func keyAlreadyExists(key: String, inPlistWithName: String) -> Bool
}
