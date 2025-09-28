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
}

class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListPresenter?
    var networkService: NetworkServiceProtocol?
    var storageService: StorageServiceProtocol?
    
    func loadTask() {
        print("Interactor: Загружаю задачи из БД...")

        let localTasks = storageService?.loadTodos() ?? []
        presenter?.tasksLoaded(localTasks)
    }
    
    func refreshFromNetwork() {
        print("Interactor: Загружаю задачи из сети...")
        
        networkService?.fetchTodos { [weak self] result in
            switch result {
            case .success(let tasks):
                print("Interactor: Получено \(tasks.count) задач из API")
                self?.storageService?.saveTodos(tasks)
                self?.presenter?.tasksLoaded(tasks)
                
            case .failure(let error):
                print("Interactor: Ошибка загрузки: \(error)")
                let localTasks = self?.storageService?.loadTodos() ?? []
                
                if localTasks.isEmpty {
                    self?.presenter?.tasksLoaded(localTasks)
                } else {
                    self?.presenter?.tasksLoaded(localTasks)
                }
            }
        }
    }
}
