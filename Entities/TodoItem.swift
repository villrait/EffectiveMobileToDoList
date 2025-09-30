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
    let createdAt: Date
    var updatedAt: Date
    var description: String?
    
    init(id: Int,
         title: String,
         isCompleted: Bool = false,
         userId: Int = 1,
         description: String? = nil) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.userId = userId
        self.createdAt = Date()
        self.updatedAt = Date()
        self.description = description
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        userId = try container.decode(Int.self, forKey: .userId)
        createdAt = Date()
        updatedAt = Date()
        description = try container.decode(String.self, forKey: .title)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case title = "todo"
        case isCompleted = "completed"
        case userId
    }
}
