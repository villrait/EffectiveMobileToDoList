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
    weak var view: TaskDetailsViewControllerProtocol?
    var interactor: TaskDetailsInteractorProtocol?
    var router: TaskDetailsRouterProtocol?
    var isEditMode: Bool = false
    
    var task: TodoItem?
    
    func viewDidLoad() {
        print("Presenter: Экран деталей загружен, режим: \(isEditMode ? "редактирование" : "просмотр")")
        guard let task = task else { return }
        print("Presenter: Task description - \(task.description ?? "nil")")
        view?.displayTask(
            title: task.title,
            taskDescription: task.description ?? "",
            isCompleted: task.isCompleted,
            isEditMode: isEditMode
        )
    }
    
    func saveTask(title: String, description: String?, isCompleted: Bool) {
        print("Presenter: Сохраняю задачу - \(title)")
        guard let task = task else { return }
        interactor?.saveTask(
            task, newTitle: title,
            newDescription: description,
            newIsCompleted: isCompleted
        )
    }
    
    func taskSavedSuccessfully() {
        print("Presenter: Задача успешно сохранена")
        router?.closeScreen()
    }
}
