//
//  TodoItem.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation

struct TodoItem: Codable {
    let id: Int
    let title: String
    let isCompleted: Bool
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case isCompleted = "completed"
        case userId
    }
}
