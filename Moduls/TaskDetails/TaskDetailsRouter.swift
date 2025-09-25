//
//  TaskDetailsRouter.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskDetailsRouterProtocol: AnyObject {
    func closeScreen()
}

class TaskDetailsRouter: TaskDetailsRouterProtocol {
    weak var viewController: TaskDetailsViewControllerProtocol?
    
    func closeScreen() {
        (viewController as? UIViewController)?.navigationController?.popViewController(animated: true)
    }
}
