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
    func saveNewTaskOnly(_ task: TodoItem)
    func updateTaskOnly(_ task: TodoItem)
    func deleteTask(_ task: TodoItem)
    func updateTaskCompletion(_ task: TodoItem, isCompleted: Bool)
}
