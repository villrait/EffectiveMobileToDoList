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
        let updatedTask = TodoItem(
            id: task.id,
            title: newTitle,
            isCompleted: newIsCompleted,
            description: task.description
        )
        
        storageService?.saveTodos([updatedTask])
        print("Interactor: Задача обновлена - \(newTitle)")
        presenter?.taskSavedSuccessfully()
    }
}
