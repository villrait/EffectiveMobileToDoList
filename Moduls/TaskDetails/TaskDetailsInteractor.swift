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
        
        if task.title.isEmpty {
            // НОВАЯ ЗАДАЧА
            let newTask = TodoItem(
                id: Int.random(in: 1000...9999),
                title: newTitle,
                isCompleted: newIsCompleted,
                userId: task.userId,
                description: newDescription
            )
            storageService?.saveNewTaskOnly(newTask)
            print("Interactor: Новая задача создана - \(newTitle)")
            
        } else {
            // РЕДАКТИРОВАНИЕ - используем метод обновления одной задачи
            let updatedTask = TodoItem(
                id: task.id,
                title: newTitle,
                isCompleted: newIsCompleted,
                userId: task.userId,
                description: newDescription
            )
            // Этот метод должен обновлять updatedAt
            storageService?.updateTaskOnly(updatedTask)
            print("Interactor: Задача отредактирована - \(newTitle)")
        }
        
        presenter?.taskSavedSuccessfully()
    }
}
