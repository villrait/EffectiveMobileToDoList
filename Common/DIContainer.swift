//
//  DIContainer.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

class DIContainer {
    
    private let networkService: NetworkServiceProtocol = NetworkService()
    private let storageService: StorageServiceProtocol = CoreDataService()
    
    func makeNetworkService() -> NetworkServiceProtocol {
        return networkService
    }
    
    func makeStorageServices() -> StorageServiceProtocol {
        return storageService
    }
}
