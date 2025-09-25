//
//  TaskListPresenter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectTask(at index: Int)
}

class TaskListPresenter: TaskListPresenterProtocol {
    func viewDidLoad() {
        print("Presenter: View загрузилась, запрашиваю данные...")
    }
    
    func didSelectTask(at index: Int) {
        print("Presenter: Выбрана задача №\(index)")
    }
    
    weak var view: TaskListViewController?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
}
