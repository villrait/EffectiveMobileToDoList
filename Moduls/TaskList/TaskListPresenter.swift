//
//  TaskListPresenter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTask(at index: Int)
    func tasksLoaded(_ tasks: [TodoItem])
    func refreshTasks()
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
        print("Presenter: Выбрана задача №\(index + 1)")
    }
}
