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
    
    // MARK: - Properties
    
    weak var view: TaskListViewController?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    private var tasks: [TodoItem] = []
    private var allTodos: [TodoItem] = []
    
    // MARK: - Lifecycle Methods
    
    func viewDidLoad() {
        interactor?.loadTask()
    }
    
    func viewWillAppear() {
        interactor?.loadTask()
    }
    
    func showLoading() {
        view?.showLoading()
    }
    
    // MARK: - Task Actions
    
    func updateTaskCompletion(at index: Int, isCompleted: Bool) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        interactor?.updateTaskCompletion(task, isCompleted: isCompleted)
    }
    
    func editTask(at index: Int) {
        guard index < tasks.count else { return }
        let selectedTask = tasks[index]
        router?.showTaskDetailsForEditing(selectedTask)
    }
    
    func didSelectTask(at index: Int) {
        guard index < tasks.count else { return }
        let selectedTask = tasks[index]
        router?.showTaskDetails(selectedTask)
    }
    
    func deleteTask(at index: Int) {
        guard index < tasks.count else { return }
        let task = tasks[index]
        interactor?.deleteTask(task)
    }
    
    func createNewTask() {
        router?.showCreateTaskScreen()
    }
    
    // MARK: - Data Management
    
    func refreshTasks() {
        view?.showLoading()
        interactor?.refreshFromNetwork()
    }
    
    func tasksLoaded(_ tasks: [TodoItem]) {
        self.tasks = tasks
        self.allTodos = tasks
        DispatchQueue.main.async {
            self.view?.displayTasks(tasks)
        }
    }
    
    func tasksLoadingFailed(_ error: Error) {
        view?.showError("Не удалось загрузить задачи: \(error.localizedDescription)")
    }
    
    func searchTasks(with query: String) {
        if query.isEmpty {
            view?.displayTasks(allTodos)
        } else {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                
                let filteredTasks = allTodos.filter { task in
                    let titleMatch = task.title.lowercased().contains(query.lowercased())
                    let descriptionMatch = task.description?.lowercased().contains(query.lowercased()) ?? false
                    return titleMatch || descriptionMatch
                }
                
                DispatchQueue.main.async {
                    self.view?.displayTasks(filteredTasks)
                }
            }
        }
    }
    
    func getTotalTasksCount() -> Int {
        return allTodos.count
    }
}
