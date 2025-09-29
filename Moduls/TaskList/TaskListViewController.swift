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
    private var tasks: [TodoItem] = []
    private let cellIdentifier = "TaskCell"
    
    private let refreshControl: UIRefreshControl = {
        $0.attributedTitle = NSAttributedString(string: "Загрузка из сети...")
        return $0
    }(UIRefreshControl())
    
    private let titleLabel: UILabel = {
        $0.text = "Задачи"
        $0.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let searchTextField: UITextField = {
        $0.placeholder = "Поиск"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .systemGray6
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextField())
    
    private let tableView: UITableView = {
        $0.separatorStyle = .none
        $0.rowHeight = 80
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView())
    
    private let bottomPanel: UIView = {
        $0.backgroundColor = .systemGray6
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private let tasksCountLabel: UILabel = {
        $0.text = "0 задач"
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let addButton:UIButton = {
        $0.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        $0.tintColor = .systemBlue
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstrains()
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(bottomPanel)
        bottomPanel.addSubview(tasksCountLabel)
        bottomPanel.addSubview(addButton)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.refreshControl = refreshControl
        
        tableView.register(TaskCell.self, forCellReuseIdentifier: cellIdentifier)
        
        addButton.addTarget(self, action: #selector(addTaskTapped), for: .touchUpInside)
    }
    
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            searchTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomPanel.topAnchor),
            
            bottomPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomPanel.heightAnchor.constraint(equalToConstant: 60),
            
            tasksCountLabel.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            tasksCountLabel.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: bottomPanel.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func displayTasks(_ tasks: [TodoItem]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            self.tasksCountLabel.text = "\(tasks.count) задач"
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Последнее обновление: \(Date().formatted())")
        }
    }
    
    func showLoading() {
        //
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func addTaskTapped() {
        //
        print("Add task tapped")
    }
    
    @objc private func refreshData() {
        print("Refresh triggered")
        presenter?.refreshTasks()
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TaskCell
        
        let task = tasks[indexPath.row]
        
        cell.configure(with: task)
        
        cell.onCheckboxTapped = { [weak self] isCompleted in
            self?.updateTaskCompletion(at: indexPath.row, isCompleted: isCompleted)
        }
        
        return cell
    }
    
    private func updateTaskCompletion(at index: Int, isCompleted: Bool) {
        guard index < tasks.count else { return }
        var task = tasks[index]
        
        let updatedTask = TodoItem(
            id: task.id,
            title: task.title,
            isCompleted: isCompleted,
            userId: task.userId,
            description: task.description
        )
        print("Task \(task.title) completion updated to: \(isCompleted)")
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectTask(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            
            let editAction = UIAction(title: "Редактировать", image: UIImage(systemName: "pencil")) { _ in
                self.presenter?.didSelectTask(at: indexPath.row)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareTask(at: indexPath.row)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash")) { _ in
                self.deleteTask(at: indexPath.row)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    private func shareTask(at index: Int) {
        let task = tasks[index]
        let text = "Задача: \(task.title)"
        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func deleteTask(at index: Int) {
        print("Delete task at index: \(index)")
    }
}
