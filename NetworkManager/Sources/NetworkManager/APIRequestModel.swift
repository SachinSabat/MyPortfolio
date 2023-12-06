//
//  APIRequestModel.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation

public struct APIRequestModel: APIModelProtocol {
    public var api: APIConfigurations
    /// An optional dictionary of parameters to include in the API request.
    public var params: [String: Any]?

    /**
     Initializes an `APIRequestModel` with the given API configuration and optional parameters.

     - Parameters:
     - api: An instance of `APIConfigurations` specifying the API endpoint and method.
     - parameters: An optional dictionary of parameters to include in the API request.
     */
   public init(api: APIConfigurations, parameters: [String: Any]? = nil) {
        self.api = api
        self.params = parameters
    }
}
