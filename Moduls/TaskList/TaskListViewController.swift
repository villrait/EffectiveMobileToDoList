//
//  TaskListViewController.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListViewControllerProtocol: AnyObject {
    
}

class TaskListViewController: UIViewController, TaskListViewControllerProtocol {
    var presenter: TaskListPresenterProtocol?
}
