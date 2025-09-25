//
//  TaskListViewController.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskListViewControllerProtocol: AnyObject {
    func displayTasks(_ tasks: [TodoItem])
    func showLoading()
    func showError(_ message: String)
}

class TaskListViewController: UIViewController, TaskListViewControllerProtocol {
    var presenter: TaskListPresenterProtocol?
    
    private let tableView = UITableView()
    private let cellIdentifier = "Cell"
    private var tasks: [TodoItem] = []
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupActivityIndicator()
        tableView.dataSource = self
        tableView.delegate = self
        presenter?.viewDidLoad()
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    func showError(_ message: String) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alert.present(alert, animated: true)
        }
    }
    
    func displayTasks(_ tasks: [TodoItem]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    func showLoading() {
        activityIndicator.startAnimating()
    }
    
    func hideRefreshIndicator() {
        refreshControl.endRefreshing()
    }
    
    @objc private func refreshData() {
        presenter?.refreshTasks()
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.title
        cell.accessoryType = task.isCompleted ? .checkmark : .none
        return cell
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTask(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
