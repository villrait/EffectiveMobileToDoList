//
//  TaskListPresenter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    
}

class TaskListPresenter: TaskListPresenterProtocol {
    weak var view: TaskListViewController?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
}
