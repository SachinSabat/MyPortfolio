//
//  NetoworkHelper.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
/// A protocol for objects that can convert an `APIModelProtocol` into a `URLRequest`.
protocol URLRequestConvertible {
    /// Converts an `APIModelProtocol` into a `URLRequest`.
    ///
    /// - Parameter apiModel: The API model to be converted.
    /// - Returns: A `URLRequest` representing the API request.
    func makeURLRequest(apiModel: APIModelProtocol) -> URLRequest
}

extension URLRequestConvertible {

    /// The method accepts `APIRequestModel` as an argument and generates `URLRequest`
    /// - Parameter apiModel: APIRequestModel
    /// - Returns: URLRequest
    func makeURLRequest(apiModel: APIModelProtocol) -> URLRequest {

        let url = getURL(requestData: apiModel)
        var request = URLRequest(url: url!)
        request.httpMethod = apiModel.api.getHTTPMethod().rawValue
        request.allHTTPHeaderFields = apiModel.api.getHeaders()

        if apiModel.api.getHTTPMethod() != .GET {
            if let params = apiModel.params {
                request.httpBody = encodeBody(bodyParameters: params)
            }
        }

        /// Returns the generated URLRequest.
        return request
    }

    /// Encodes a dictionary of body parameters into JSON data.
    ///
    /// - Parameter bodyParameters: The dictionary of body parameters to be encoded.
    /// - Returns: JSON data representing the encoded parameters, or `nil` if encoding fails.
    private func encodeBody(bodyParameters: [String: Any]) -> Data? {
        return try? JSONSerialization.data(withJSONObject: bodyParameters as Any,
                                           options: .prettyPrinted)
    }

    /// Generates a URL for the API request based on the provided `APIModelProtocol`.
    ///
    /// - Parameter requestData: The APIModelProtocol containing information for building the URL.
    /// - Returns: A URL for the API request, or `nil` if it cannot be constructed.
    private func getURL(requestData: APIModelProtocol) ->  URL? {
        // Escape the API path to handle special characters in the URL.
        guard let escapedAddress = requestData.api.getAPIPath().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return nil
        }
        let urlComp = NSURLComponents(string: escapedAddress)
        // If the HTTP method is GET, return the URL without query parameters.
        guard requestData.api.getHTTPMethod() != .GET else {
            return urlComp?.url
        }

        var items = [URLQueryItem]()
        // Check if there are parameters to add to the URL.
        if let params: [String: Any] = requestData.params, !params.isEmpty {
            for (key,value) in params {
                if let value: String = value as? String {
                    items.append(URLQueryItem(name: key, value: value))
                }
            }
        }
        // Filter out empty query items.
        items = items.filter{!$0.name.isEmpty}
        // If there are non-empty query items, add them to the URL.
        if !items.isEmpty {
            urlComp?.queryItems = items
        }
        return urlComp?.url
    }
}
