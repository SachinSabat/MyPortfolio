//
//  PlistEnums.swift
//
//
//  Created by Sachin Sabat on 05/01/24.
//

import Foundation

// MARK: - Plist Action Enumeration

/// Enumeration defining actions related to plist operations.
public enum PlistAction {
    case addNewValue
    case saveValue
    case fetchValue
    case getValue
    case removeKeyValue
    case removeAllKeyValue
}

// MARK: - Plist Data Structure

/// Structure representing data for plist operations.
public struct PlistData {
    var value: Any
    var key: String
    var plistName: String
    var plistAction: PlistAction
}

// MARK: - Plist Manager Error Enumeration

/// Enumeration defining errors related to plist manager operations.
public enum PlistManagerError: Error {
    case fileNotWritten
    case fileDoesNotExist
    case fileUnavailable
    case fileAlreadyEmpty
    case keyValuePairAlreadyExists
    case keyValuePairDoesNotExist
}
