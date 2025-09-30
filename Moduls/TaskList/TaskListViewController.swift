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
        $0.rowHeight = UITableView.automaticDimension
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
        $0.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        $0.tintColor = .systemBlue
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
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
        view.backgroundColor = .systemBackground
        
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
        
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        searchTextField.delegate = self
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
            bottomPanel.heightAnchor.constraint(equalToConstant: 80),
            
            tasksCountLabel.centerXAnchor.constraint(equalTo: bottomPanel.centerXAnchor),
            tasksCountLabel.topAnchor.constraint(equalTo: bottomPanel.topAnchor, constant: 20),
            
            addButton.trailingAnchor.constraint(equalTo: bottomPanel.trailingAnchor, constant: -50),
            addButton.centerYAnchor.constraint(equalTo: tasksCountLabel.centerYAnchor)
        ])
    }
    
    func displayTasks(_ tasks: [TodoItem]) {
        self.tasks = tasks
        DispatchQueue.main.async {
            let searchText = self.searchTextField.text ?? ""
            if searchText.isEmpty {
                self.tasksCountLabel.text = "\(tasks.count) задач"
            } else {
                self.tasksCountLabel.text = "Найдено: \(tasks.count) из \(self.getTotalTasksCount())"
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.refreshControl.attributedTitle = NSAttributedString(string: "Последнее обновление: \(Date().formatted())")
        }
    }

    private func getTotalTasksCount() -> Int {
        return tasks.count
    }
    
    func showLoading() {
        refreshControl.beginRefreshing()
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func addTaskTapped() {
        presenter?.createNewTask()
        print("Add task tapped")
    }
    
    @objc private func refreshData() {
        print("Refresh triggered")
        presenter?.refreshTasks()
    }
    
    @objc private func searchTextChanged() {
        let searchText = searchTextField.text ?? ""
        presenter?.searchTasks(with: searchText)
    }
}

extension TaskListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        presenter?.updateTaskCompletion(at: index, isCompleted: isCompleted)
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
                self.presenter?.editTask(at: indexPath.row)
            }
            
            let shareAction = UIAction(title: "Поделиться", image: UIImage(systemName: "square.and.arrow.up")) { _ in
                self.shareTask(at: indexPath.row)
            }
            
            let deleteAction = UIAction(title: "Удалить", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.showDeleteConfirmation(for: indexPath.row)
            }
            
            return UIMenu(title: "", children: [editAction, shareAction, deleteAction])
        }
    }
    
    private func shareTask(at index: Int) {
        let task = tasks[index]
        
        var shareText = "📋 \(task.title)"
        
        if let description = task.description, !description.isEmpty {
            shareText += "\n\n\(description)"
        }
        
        shareText += "\n\n📅 Создано: \(formatDate(task.createdAt))"
        shareText += "\n✅ Статус: \(task.isCompleted ? "Выполнено" : "Не выполнено")"
        
        let activityVC = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func showDeleteConfirmation(for index: Int) {
        guard index < tasks.count else { return }
        
        let task = tasks[index]
        
        let alert = UIAlertController(
            title: "Удалить задачу?",
            message: "Задача \"\(task.title)\" будет удалена. Это действие нельзя отменить.",
            preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            self.deleteTask(at: index)
        }
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formater = DateFormatter()
        formater.dateFormat = "dd.MM.yyyy"
        return formater.string(from: date)
    }
    
    private func deleteTask(at index: Int) {
        presenter?.deleteTask(at: index)
    }
}
