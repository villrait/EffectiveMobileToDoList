//
//  TaskListRouter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListRouterProtocol: AnyObject {
    func showTaskDetails(_ task: TodoItem)
}

class TaskListRouter: TaskListRouterProtocol {
    weak var viewController: TaskListViewController?
    
    func showTaskDetails(_ task: TodoItem) {
        guard let sourceVC = viewController as? UIViewController else { return }
    
        let diContainer = DIContainer()
        let detailsVC = diContainer.makeTaskDetailsModule(task: task)
        sourceVC.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
