//
//  CoreDataService.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

class CoreDataService: StorageServiceProtocol {
    func saveTodos(_ todos: [TodoItem]) {
        print("Saving \(todos.count) todos to CoreData")
    }
    
    func loadTodos() -> [TodoItem] {
        print("Loading todos from CoreData")
        return []
    }
}
