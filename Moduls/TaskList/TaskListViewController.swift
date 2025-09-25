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
    
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        tableView.dataSource = self
        tableView.delegate = self
        presenter?.viewDidLoad()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = "Задача \(indexPath.row + 1)"
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTask(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
