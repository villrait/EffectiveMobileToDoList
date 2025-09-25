//
//  TaskListConfigurator.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

class TaskListConfigurator {
    func configure() -> TaskListViewController {
        let viewController = TaskListViewController()
        let presenter = TaskListPresenter()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
