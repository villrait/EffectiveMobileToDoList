//
//  StorageServiceProtocol.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

protocol StorageServiceProtocol {
    func saveTodos(_ todos: [TodoItem])
    func loadTodos() -> [TodoItem]
}
