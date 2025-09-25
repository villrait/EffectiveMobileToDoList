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
}

class TaskListPresenter: TaskListPresenterProtocol {
    
    weak var view: TaskListViewController?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
    private var tasks: [TodoItem] = []
    
    func viewDidLoad() {
        print("Presenter: View загрузилась, запрашиваю данные...")
        view?.showLoading()
        interactor?.loadTask()
    }
    
    func viewWillAppear() {
        print("Presenter: Экран появляется, обновляю данные...")
        interactor?.loadTask()
    }
    
    func tasksLoadingFailed(_ error: any Error) {
        view?.showError("Не удалось загрузить задачи: \(error.localizedDescription)")
    }
    
    func refreshTasks() {
        print("Presenter: Обновляю задачи...")
        interactor?.loadTask()
    }
    
    func tasksLoaded(_ tasks: [TodoItem]) {
        print("Presenter: Получено \(tasks.count) задач")
        self.tasks = tasks
        view?.displayTasks(tasks)
    }
    
    func didSelectTask(at index: Int) {
        guard index < tasks.count else { return }
        let selectedTask = tasks[index]
        print("Presenter: Выбрана задача - \(selectedTask.title)")
        router?.showTaskDetails(selectedTask)
    }
}
