//
//  TaskDetailsViewController.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskDetailsViewControllerProtocol: AnyObject {
    func displayTask(title: String, taskDescription: String, isCompleted: Bool, isEditMode: Bool)
    func setupEditMode(_ isEditMode: Bool)
}

class TaskDetailsViewController: UIViewController, TaskDetailsViewControllerProtocol {
    
    // MARK: - Properties
    
    var presenter: TaskDetailsPresenterProtocol?
    
    // MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.numberOfLines = 0
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let dateLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private let descriptionTextView: UITextView = {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.isEditable = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextView())
    
    private let titleTextView: UITextView = {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        $0.isScrollEnabled = false
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 8
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextView())
    
    private let editableDescriptionTextView: UITextView = {
        $0.font = UIFont.systemFont(ofSize: 16)
        $0.layer.borderColor = UIColor.systemGray4.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 8
        $0.isHidden = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITextView())
    
    private let saveButton = UIBarButtonItem()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        
        titleTextView.delegate = self
        editableDescriptionTextView.delegate = self
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(titleTextView)
        view.addSubview(editableDescriptionTextView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            descriptionTextView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            titleTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            
            editableDescriptionTextView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 20),
            editableDescriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            editableDescriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            editableDescriptionTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
        
        saveButton.title = "Сохранить"
        saveButton.target = self
        saveButton.action = #selector(saveTapped)
        saveButton.isEnabled = false
    }
    
    private func updateSaveButtonState() {
        let title = titleTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        saveButton.isEnabled = !title.isEmpty
    }
    
    // MARK: - TaskDetailsViewControllerProtocol
    
    func displayTask(title: String, taskDescription: String, isCompleted: Bool, isEditMode: Bool) {
        titleLabel.text = title
        descriptionTextView.text = taskDescription
        titleTextView.text = title
        editableDescriptionTextView.text = taskDescription
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: Date())
        
        setupEditMode(isEditMode)
    }
    
    func setupEditMode(_ isEditMode: Bool) {
        titleLabel.isHidden = isEditMode
        descriptionTextView.isHidden = isEditMode
        dateLabel.isHidden = isEditMode
        titleTextView.isHidden = !isEditMode
        editableDescriptionTextView.isHidden = !isEditMode
        
        if isEditMode {
            navigationItem.rightBarButtonItem = saveButton
            title = "Редактирование"
        } else {
            navigationItem.rightBarButtonItem = nil
            title = "Детали задачи"
        }
    }
    
    // MARK: - Actions
    
    @objc private func saveTapped() {
        let title = titleTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        guard !title.isEmpty else { return }
        
        presenter?.saveTask(
            title: titleTextView.text ?? "",
            description: editableDescriptionTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines),
            isCompleted: false
        )
    }
}

// MARK: - UITextViewDelegate

extension TaskDetailsViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateSaveButtonState()
    }
}
