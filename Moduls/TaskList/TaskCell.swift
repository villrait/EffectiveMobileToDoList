//
//  TaskCell.swift
//  EffectiveMobileToDoList
//
//  Created by м on 29.09.2025.
//

import UIKit

class TaskCell: UITableViewCell {
    
    private let checkButton: UIButton = {
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
        $0.tintColor = .systemBlue
        return $0
    }(UIButton())
    
    private let titleLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.numberOfLines = 1
        return $0
    }(UILabel())
    
    private let descriptionLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .gray
        $0.numberOfLines = 2
        return $0
    }(UILabel())
    
    private let dateLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .lightGray
        return $0
    }(UILabel())
    
    private let separator: UIView = {
        $0.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return $0
    }(UIView())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [checkButton, titleLabel, descriptionLabel, dateLabel, separator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            checkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            checkButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkButton.widthAnchor.constraint(equalToConstant: 24),
            checkButton.heightAnchor.constraint(equalToConstant: 24),
            
            
            titleLabel.leadingAnchor.constraint(equalTo: checkButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            
            
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            
            
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 4),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    @objc private func checkButtonTapped() {
        checkButton.isSelected.toggle()
        updateTitleStrikeThrough()
    }
    
    func configure(with task: TodoItem) {
        titleLabel.text = task.title
        descriptionLabel.text = task.description ?? "Нет описания"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateLabel.text = formatter.string(from: task.createdAt)
        
        checkButton.isSelected = task.isCompleted
        updateTitleStrikeThrough()
    }
    
    private func updateTitleStrikeThrough() {
        let attributeString = NSMutableAttributedString(string: titleLabel.text ?? "")
        
        if checkButton.isSelected {
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
        } else {
            attributeString.removeAttribute(.strikethroughStyle, range: NSRange(location: 0, length: attributeString.length))
        }
        titleLabel.attributedText = attributeString
    }
    
}
