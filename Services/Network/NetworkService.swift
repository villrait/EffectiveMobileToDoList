//
//  NetworkService.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoItem], any Error>) -> Void) {
        
        let url = URL(string: "https://dummyjson.com/todos")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.success([]))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(response.todos))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    struct TodoResponse: Codable {
        let todos: [TodoItem]
    }
}
