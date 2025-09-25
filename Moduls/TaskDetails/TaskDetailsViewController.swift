//
//  TaskDetailsViewController.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import UIKit

protocol TaskDetailsViewControllerProtocol: AnyObject {
    
}

class TaskDetailsViewController: UIViewController, TaskDetailsViewControllerProtocol {
    var presenter: TaskDetailsPresenterProtocol?
    
    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let completedSwitch = UISwitch()
    private let saveButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        titleTextField.borderStyle = .roundedRect
        titleTextField.placeholder = "Название задачи"
        
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.cornerRadius = 3
        
        completedSwitch.isOn = false
        
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [
            titleTextField, descriptionTextView, completedSwitch, saveButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func saveTapped() {
        presenter?.saveTask(
            title: titleTextField.text ?? "",
            description: descriptionTextView.text,
            isCompleted: completedSwitch.isOn
        )
    }
}
