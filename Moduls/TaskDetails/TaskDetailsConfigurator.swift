//
//  TaskDetailsConfigurator.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

class TaskDetailsConfigurator {
    func configure(with task: TodoItem) -> TaskDetailsViewController {
        let viewController = TaskDetailsViewController()
        let presenter = TaskDetailsPresenter()
        let interactor = TaskDetailsInteractor()
        let router = TaskDetailsRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        presenter.task = task
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
