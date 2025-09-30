//
//  TaskListPresenter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func didSelectTask(at index: Int)
    func tasksLoaded(_ tasks: [TodoItem])
    func refreshTasks()
    func tasksLoadingFailed(_ error: Error)
    func updateTaskCompletion(at index: Int, isCompleted: Bool)
    func editTask(at index: Int)
    func deleteTask(at index: Int)
    func createNewTask()
    func searchTasks(with query: String)
    func getTotalTasksCount() -> Int
    func showLoading()
}

class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TaskListViewController?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    private var tasks: [TodoItem] = []
    private var todos: [TodoItem] = []
    private var allTodos: [TodoItem] = []
    
    func viewDidLoad() {
        print("Presenter: View загрузилась, показываю локальные данные...")
        interactor?.loadTask()
    }
    
    func refreshTasks() {
        print("Presenter: Принудительное обновление из сети...")
        view?.showLoading()
        interactor?.refreshFromNetwork()
    }
    
    func viewWillAppear() {
        print("Presenter: Экран появляется, обновляю локальные данные...")
        interactor?.loadTask()
    }
    
    func updateTaskCompletion(at index: Int, isCompleted: Bool) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        interactor?.updateTaskCompletion(task, isCompleted: isCompleted)
    }
    
    func tasksLoadingFailed(_ error: any Error) {
        view?.showError("Не удалось загрузить задачи: \(error.localizedDescription)")
    }
    
    func tasksLoaded(_ tasks: [TodoItem]) {
        print("Presenter: Получено \(tasks.count) задач")
        self.tasks = tasks
        self.allTodos = tasks
        DispatchQueue.main.async{
            self.view?.displayTasks(tasks)
        }
    }
    
    func showLoading() {
        view?.showLoading()
    }
    
    func editTask(at index: Int) {
        guard index < tasks.count else { return }
        let selectedTask = tasks[index]
        print("Presenter: Редактируем задачу - \(selectedTask.title)")
        router?.showTaskDetailsForEditing(selectedTask)
    }
    
    func didSelectTask(at index: Int) {
        guard index < tasks.count else { return }
        let selectedTask = tasks[index]
        print("Presenter: Выбрана задача - \(selectedTask.title)")
        router?.showTaskDetails(selectedTask)
    }
    
    func deleteTask(at index: Int) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        print("Presenter: Удаляем задачу - \(task.title)")
        interactor?.deleteTask(task)
    }
    
    func createNewTask() {
        print("Presenter: Создаем новую задачу")
        router?.showCreateTaskScreen()
    }
    
    func searchTasks(with query: String) {
        print("Presenter: Searching tasks with query: '\(query)'")
        
        if query.isEmpty {
            self.todos = allTodos
            view?.displayTasks(allTodos)
        } else {
            let filteredTasks = allTodos.filter { task in
                let titleMatch = task.title.lowercased().contains(query.lowercased())
                let descriptionMatch = task.description?.lowercased().contains(query.lowercased()) ?? false
                return titleMatch || descriptionMatch
            }
            self.todos = filteredTasks
            print("Presenter: Found \(filteredTasks.count) tasks matching '\(query)'")
            view?.displayTasks(filteredTasks)
        }
    }
    
    func getTotalTasksCount() -> Int {
        return allTodos.count
    }
}
