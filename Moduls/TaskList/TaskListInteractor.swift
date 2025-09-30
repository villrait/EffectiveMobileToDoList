//
//  TaskListInteractor.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    func loadTask()
    func refreshFromNetwork()
    func updateTaskCompletion(_ task: TodoItem, isCompleted: Bool)
    func deleteTask(_ task: TodoItem)
}

class TaskListInteractor: TaskListInteractorProtocol {
    
    // MARK: - Properties
    
    weak var presenter: TaskListPresenter?
    var networkService: NetworkServiceProtocol?
    var storageService: StorageServiceProtocol?
    
    // MARK: - TaskListInteractorProtocol
    
    func updateTaskCompletion(_ task: TodoItem, isCompleted: Bool) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.storageService?.updateTaskCompletion(task, isCompleted: isCompleted)
            
            let currentTasks = self?.storageService?.loadTodos() ?? []
            
            DispatchQueue.main.async {
                self?.presenter?.tasksLoaded(currentTasks)
            }
        }
    }
    
    func loadTask() {
        let localTasks = storageService?.loadTodos() ?? []
        
        if localTasks.isEmpty {
            refreshFromNetwork()
        } else {
            presenter?.tasksLoaded(localTasks)
        }
    }
    
    func refreshFromNetwork() {
        DispatchQueue.main.async {
            self.presenter?.showLoading()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.networkService?.fetchTodos { [weak self] result in
                switch result {
                case .success(let tasks):
                    self?.storageService?.saveTodos(tasks)
                    let updatedTasks = self?.storageService?.loadTodos() ?? []
                    
                    DispatchQueue.main.async {
                        self?.presenter?.tasksLoaded(updatedTasks)
                    }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        let localTasks = self?.storageService?.loadTodos() ?? []
                        self?.presenter?.tasksLoaded(localTasks)
                        self?.presenter?.tasksLoadingFailed(error)
                    }
                }
            }
        }
    }
    
    func deleteTask(_ task: TodoItem) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.storageService?.deleteTask(task)
            
            let updatedTasks = self?.storageService?.loadTodos() ?? []
            
            DispatchQueue.main.async {
                self?.presenter?.tasksLoaded(updatedTasks)
            }
        }
    }
}
