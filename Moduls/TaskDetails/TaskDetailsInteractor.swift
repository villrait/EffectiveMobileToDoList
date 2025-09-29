//
//  TaskDetailsInteractor.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

protocol TaskDetailsInteractorProtocol: AnyObject {
    func saveTask(_ task: TodoItem, newTitle: String, newDescription: String?, newIsCompleted: Bool)
}

class TaskDetailsInteractor: TaskDetailsInteractorProtocol {
    weak var presenter: TaskDetailsPresenterProtocol?
    var storageService: StorageServiceProtocol?
    
    func saveTask(_ task: TodoItem, newTitle: String, newDescription: String?, newIsCompleted: Bool) {
        
        let currentTasks = storageService?.loadTodos() ?? []
        
        var updatedTasks = currentTasks
        if let index = updatedTasks.firstIndex(where: { $0.id == task.id }) {
            let updatedTask = TodoItem(
                id: task.id,
                title: newTitle,
                isCompleted: newIsCompleted,
                userId: task.userId,
                description: newDescription
            )
            updatedTasks[index] = updatedTask
        }
        
        storageService?.saveTodos(updatedTasks)
        print("Interactor: Задача обновлена - \(newTitle), описание: \(newDescription ?? "nil")")
        presenter?.taskSavedSuccessfully()
    }
}
