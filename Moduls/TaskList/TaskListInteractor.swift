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
    weak var presenter: TaskListPresenter?
    var networkService: NetworkServiceProtocol?
    var storageService: StorageServiceProtocol?
    
    func updateTaskCompletion(_ task: TodoItem, isCompleted: Bool) {
        storageService?.updateTaskCompletion(task, isCompleted: isCompleted)
        print("Interactor: Task completion updated - \(task.title): \(isCompleted)")
        
        let currentTasks = storageService?.loadTodos() ?? []
        presenter?.tasksLoaded(currentTasks)
    }
    
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
        print("📱 Текущий поток: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
        
        DispatchQueue.main.async {
            print("🔄 Показываем спиннер в: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
            self.presenter?.showLoading()
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            print("🌐 Сетевой запрос в: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
            
            self.networkService?.fetchTodos { [weak self] result in
                print("📥 Получили ответ в: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
                
                switch result {
                case .success(let tasks):
                    print("Interactor: Получено \(tasks.count) задач из API")
                    self?.storageService?.saveTodos(tasks)
                    let updateTasks = self?.storageService?.loadTodos() ?? []
                    
                    DispatchQueue.main.async {
                        print("🎨 Обновляем UI в: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
                        self?.presenter?.tasksLoaded(updateTasks)
                    }
                    
                case .failure(let error):
                    print("Interactor: Ошибка загрузки: \(error)")
                    DispatchQueue.main.async {
                        let localTasks = self?.storageService?.loadTodos() ?? []
                        self?.presenter?.tasksLoaded(localTasks)
                    }
                }
            }
        }
    }
    
    func deleteTask(_ task: TodoItem) {
        print("🗑️ Начинаем удаление задачи: \(task.title)")
        
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            print("🗑️ Удаление задачи в: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
            self?.storageService?.deleteTask(task)
            
            let updatedTasks = self?.storageService?.loadTodos() ?? []
            
            DispatchQueue.main.async{
                print("🗑️ Удаление завершено, обновляем UI в: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
                self?.presenter?.tasksLoaded(updatedTasks)
            }
        }
    }
}
