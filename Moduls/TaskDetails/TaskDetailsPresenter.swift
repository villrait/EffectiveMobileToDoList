//
//  TaskDetailsPresenter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

protocol TaskDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func saveTask(title: String, description: String?, isCompleted: Bool)
}

class TaskDetailsPresenter: TaskDetailsPresenterProtocol {
    weak var view: TaskDetailsViewControllerProtocol?
    var interactor: TaskDetailsInteractorProtocol?
    var router: TaskDetailsRouterProtocol?
    
    var task: TodoItem?
    
    func viewDidLoad() {
        print("Presenter: Экран деталей загружен")
        guard let task = task else { return }
        view?.displayTask(
            title: task.title,
            description: "",
            isCompleted: task.isCompleted
        )
    }
    
    func saveTask(title: String, description: String?, isCompleted: Bool) {
        print("Presenter: Сохраняю задачу - \(title)")
    }
}
