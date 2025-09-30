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
    func taskSavedSuccessfully()
}

class TaskDetailsPresenter: TaskDetailsPresenterProtocol {
    
    // MARK: - Properties
    
    weak var view: TaskDetailsViewControllerProtocol?
    var interactor: TaskDetailsInteractorProtocol?
    var router: TaskDetailsRouterProtocol?
    var isEditMode: Bool = false
    var task: TodoItem?
    
    // MARK: - TaskDetailsPresenterProtocol
    
    func viewDidLoad() {
        guard let task = task else { return }
        view?.displayTask(
            title: task.title,
            taskDescription: task.description ?? "",
            isCompleted: task.isCompleted,
            isEditMode: isEditMode
        )
    }
    
    func saveTask(title: String, description: String?, isCompleted: Bool) {
        guard let task = task else { return }
        interactor?.saveTask(
            task,
            newTitle: title,
            newDescription: description,
            newIsCompleted: isCompleted
        )
    }
    
    func taskSavedSuccessfully() {
        router?.closeScreen()
    }
}
