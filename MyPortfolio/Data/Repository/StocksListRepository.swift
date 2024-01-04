//
//  StocksListRepository.swift
//  MyPortfolio
//
//  Created by Sachin Sabat on 2023-10-10.
//

import Foundation
import Combine
import NetworkManager
import DataManager

/// A repository class responsible for handling data related to the stocks list.
///
/// This class is used to interact with the network service to fetch data for the stocks list.
///
/// Important:
/// Make sure to provide a `NetworkService` instance when initializing this class to enable data fetching functionality.
///
/// See Also:
/// - `NetworkService`: The service responsible for network-related operations.
final class StocksListRepository {

    /// The network service responsible for data fetching.
    private var dataManager: DataManagerProtocol
    var cancellable = Set<AnyCancellable>()
    /// Initializes a new `StocksListRepository` instance.
    ///
    /// - Parameter network: The network service responsible for data fetching.
    init(
        dataManager: DataManagerProtocol
    ) {
        self.dataManager = dataManager
    }
}

/// An extension of `StocksListRepository` conforming to `StocksListRepositoryProtocol`.
extension StocksListRepository: StocksListRepositoryProtocol {
    /// Fetches the stocks list data asynchronously.
    ///
    /// This method communicates with the network service to retrieve data for the stocks list.
    ///
    /// - Parameter completion: A closure that is called once the data fetch operation is complete.
    ///                         It provides a result that contains either the fetched `StocksListDomainModel` or a `NetworkError`.
    func fetchStocksList() -> AnyPublisher<StocksListDomainModel, NetworkError> {
        let model = APIRequestModel(api: StocksAPI.getStocksList)
        // Use the network service to fetch data and handle the result.
        return dataManager.executeRequest(with: model,
                                          objectType: StocksListModelDTO.self,
                                          requestType: .APIREQUEST(cacheName: cacheName.Portfolio.rawValue))
        .map({ result in
            return result.toDomain()
        })
        .eraseToAnyPublisher()
    }
}
