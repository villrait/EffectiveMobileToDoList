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
        
        var currentTasks = storageService?.loadTodos() ?? []
        
        if task.title.isEmpty {
            let newTask = TodoItem(
                id: Int.random(in: 1000...9999),
                title: newTitle,
                isCompleted: newIsCompleted,
                userId: task.userId,
                description: newDescription
            )
            currentTasks.insert(newTask, at: 0)
            print("Interactor: Новая задача создана - \(newTitle)")
        } else {
            if let index = currentTasks.firstIndex(where: { $0.id == task.id }) {
                let updatedTask = TodoItem(
                    id: task.id,
                    title: newTitle,
                    isCompleted: newIsCompleted,
                    userId: task.userId,
                    description: newDescription
                )
                currentTasks[index] = updatedTask
                print("Interactor: Задача обновлена - \(newTitle)")
            }
        }
        
        storageService?.saveTodos(currentTasks)
        print("Interactor: Задача обновлена - \(newTitle), описание: \(newDescription ?? "nil")")
        presenter?.taskSavedSuccessfully()
    }
}
