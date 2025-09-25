//
//  NetworkService.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        completion(.success([]))
    }
}
