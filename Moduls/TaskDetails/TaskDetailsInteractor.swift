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
    
    // MARK: - Properties
    
    weak var presenter: TaskDetailsPresenterProtocol?
    var storageService: StorageServiceProtocol?
    
    // MARK: - TaskDetailsInteractorProtocol
    
    func saveTask(_ task: TodoItem, newTitle: String, newDescription: String?, newIsCompleted: Bool) {
        if task.title.isEmpty {
            let newTask = TodoItem(
                id: Int.random(in: 1000...9999),
                title: newTitle,
                isCompleted: newIsCompleted,
                userId: task.userId,
                description: newDescription
            )
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.storageService?.saveNewTaskOnly(newTask)
                
                DispatchQueue.main.async {
                    self?.presenter?.taskSavedSuccessfully()
                }
            }
            
        } else {
            let updatedTask = TodoItem(
                id: task.id,
                title: newTitle,
                isCompleted: newIsCompleted,
                userId: task.userId,
                description: newDescription
            )
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.storageService?.updateTaskOnly(updatedTask)
                
                DispatchQueue.main.async {
                    self?.presenter?.taskSavedSuccessfully()
                }
            }
        }
    }
}
