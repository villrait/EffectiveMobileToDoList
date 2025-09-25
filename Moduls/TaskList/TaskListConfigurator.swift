//
//  TaskListConfigurator.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

class TaskListConfigurator {
    func configure(
        networkService: NetworkServiceProtocol,
        storageService: StorageServiceProtocol
    ) -> TaskListViewController {
        
        let viewController = TaskListViewController()
        let presenter = TaskListPresenter()
        let interactor = TaskListInteractor()
        let router = TaskListRouter()
        
        interactor.networkService = networkService
        interactor.storageService = storageService
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = viewController
        
        return viewController
    }
}
