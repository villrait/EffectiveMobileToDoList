//
//  NetworkServiceProtocol.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchTodos(completion: @escaping (Result<[TodoItem], Error>) -> Void)
}
