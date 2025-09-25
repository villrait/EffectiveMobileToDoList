//
//  TaskListInteractor.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

protocol TaskListInteractorProtocol: AnyObject {
    
}

class TaskListInteractor: TaskListInteractorProtocol {
    weak var presenter: TaskListPresenter?
}
