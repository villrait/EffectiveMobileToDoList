//
//  TaskListRouter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    func showTaskDetails(_ task: TodoItem)
    func showTaskDetailsForEditing(_ task: TodoItem)
    func showCreateTaskScreen()
}

class TaskListRouter: TaskListRouterProtocol {
    
    // MARK: - Properties
    
    weak var viewController: TaskListViewController?
    
    // MARK: - TaskListRouterProtocol
    
    func showTaskDetails(_ task: TodoItem) {
        showTaskDetails(task, isEditMode: false)
    }
    
    func showTaskDetailsForEditing(_ task: TodoItem) {
        showTaskDetails(task, isEditMode: true)
    }
    
    func showCreateTaskScreen() {
        guard let sourceVC = viewController else { return }
        
        let newTask = TodoItem(
            id: Int.random(in: 1000...9999),
            title: "",
            isCompleted: false,
            userId: 1,
            description: nil
        )
        
        let diContainer = DIContainer()
        let detailVC = diContainer.makeTaskDetailsModule(task: newTask)
        
        if let presenter = detailVC.presenter as? TaskDetailsPresenter {
            presenter.isEditMode = true
            presenter.task = newTask
        }
        
        sourceVC.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func showTaskDetails(_ task: TodoItem, isEditMode: Bool) {
        guard let sourceVC = viewController else { return }
        
        let diContainer = DIContainer()
        let detailsVC = diContainer.makeTaskDetailsModule(task: task)
        
        if let presenter = detailsVC.presenter as? TaskDetailsPresenter {
            presenter.isEditMode = isEditMode
        }
        
        sourceVC.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
