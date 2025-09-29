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
}

class TaskListRouter: TaskListRouterProtocol {
    weak var viewController: TaskListViewController?
    
    func showTaskDetails(_ task: TodoItem){
        showTaskDetails(task, isEditMode: false)
    }
    
    func showTaskDetailsForEditing(_ task: TodoItem){
        showTaskDetails(task, isEditMode: true)
    }
    
    func showTaskDetails(_ task: TodoItem, isEditMode: Bool) {
        guard let sourceVC = viewController as? UIViewController else { return }
    
        let diContainer = DIContainer()
        let detailsVC = diContainer.makeTaskDetailsModule(task: task)
        
        if let detailVC = detailsVC as? TaskDetailsViewController, let presenter = detailVC.presenter as? TaskDetailsPresenter {
            presenter.isEditMode = isEditMode
        }
        
        sourceVC.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
