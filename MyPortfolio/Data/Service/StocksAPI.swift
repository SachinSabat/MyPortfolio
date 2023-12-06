//
//  StocksAPI.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
import NetworkManager

//URL list
fileprivate enum StocksAPIConstants {
    static var baseURL = "https://run.mocky.io"
    static var stocksList = "/v3/a6376fa8-18f8-4d64-8adb-18fe376b699a"
}

// Types of cases to get data
enum StocksAPI {
    case getStocksList
}

extension StocksAPI: APIConfigurations {

    /**
     Returns the HTTP method associated with a specific API endpoint.

     This function is used to determine the HTTP method (GET, POST, PUT, DELETE, etc.) for a particular API endpoint defined in an enumeration conforming to the `APIConfigurations` protocol.

     - Returns: An `HTTPMethod` value representing the HTTP method for the API endpoint.
     */
    func getHTTPMethod() -> HTTPMethod {
        var methodType = HTTPMethod.GET
        switch self {
        case .getStocksList:
            methodType = .GET
        }
        return methodType
    }

    /**
     Returns the API path for the specified API endpoint.

     - Returns: A string representing the API path.
     */
    func getAPIPath() -> String {
        var endPoint = getAPIBasePath()
        switch self {
        case .getStocksList:
            endPoint += StocksAPIConstants.stocksList
        }
        return endPoint
    }

    /**
     Returns the base path for the specified API endpoint.

     - Returns: A string representing the base path of the API.
     */
    func getAPIBasePath() -> String {
        switch self {
        case .getStocksList:
            return StocksAPIConstants.baseURL
        }
    }

    /**
     Returns the headers for the specified API endpoint.

     - Returns: A dictionary containing HTTP headers.
     */
    func getHeaders() -> [String: String] {
        var headerDict = [String: String]()
        headerDict["Content-Type"] = "application/json"
        return headerDict
    }
}

