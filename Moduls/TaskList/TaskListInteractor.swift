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
}

class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListPresenter?
    var networkService: NetworkServiceProtocol?
    var storageService: StorageServiceProtocol?
    
    func loadTask() {
        print("Interactor: Загружаю задачи из БД...")
        
        let localTasks = storageService?.loadTodos() ?? []
        
        if localTasks.isEmpty {
            print("Interactor: БД пустая, загружаю из сети...")
            refreshFromNetwork()
        } else {
            print("Interactor: Найдено \(localTasks.count) задач в БД")
            presenter?.tasksLoaded(localTasks)
        }
    }
    
    func refreshFromNetwork() {
        print("Interactor: Полная перезагрузка из сети...")
        
        networkService?.fetchTodos { [weak self] result in
            switch result {
            case .success(let tasks):
                print("Interactor: Получено \(tasks.count) задач из API")
                self?.storageService?.saveTodos(tasks)
                let updateTasks = self?.storageService?.loadTodos() ?? []
                self?.presenter?.tasksLoaded(updateTasks)
                
            case .failure(let error):
                print("Interactor: Ошибка загрузки: \(error)")
                let localTasks = self?.storageService?.loadTodos() ?? []
                self?.presenter?.tasksLoaded(localTasks)
                
            }
        }
    }
    
    func updateTaskCompletion(_ task: TodoItem, isCompleted: Bool) {
        let updatedTask = TodoItem(
            id: task.id,
            title: task.title,
            isCompleted: isCompleted,
            userId: task.userId,
            description: task.description
        )
        
        
        var currentTasks = storageService?.loadTodos() ?? []
        if let index = currentTasks.firstIndex(where: { $0.id == task.id }) {
            currentTasks[index] = updatedTask
            storageService?.saveTodos(currentTasks)
            print("Interactor: Task completion updated - \(task.title): \(isCompleted)")
        }
    }
}
