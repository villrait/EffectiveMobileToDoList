//
//  EffectiveMobileToDoListTests.swift
//  EffectiveMobileToDoListTests
//
//  Created by м on 25.09.2025.
//

import XCTest
@testable import EffectiveMobileToDoList

final class EffectiveMobileToDoListTests: XCTestCase {

    func testTodoItemCreation() {
        let task = TodoItem(
            id: 1,
            title: "Buy milk",
            isCompleted: false,
            userId: 123,
            description: "Don't forget to buy milk"
        )
        
        XCTAssertEqual(task.id, 1)
        XCTAssertEqual(task.title, "Buy milk")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.userId, 123)
        XCTAssertEqual(task.description, "Don't forget to buy milk")
    }
    
    func testTodoItemDefaultValues() {
        let task = TodoItem(id: 2, title: "Simple task")
        
        XCTAssertEqual(task.id, 2)
        XCTAssertEqual(task.title, "Simple task")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.userId, 1)
        XCTAssertNil(task.description)
    }
    
    func testTodoItemCompletionToggle() {
        let task = TodoItem(id: 3, title: "Task")
        
        let completedTask = TodoItem(
            id: task.id,
            title: task.title,
            isCompleted: true,
            userId: task.userId,
            description: task.description
        )
        
        XCTAssertTrue(completedTask.isCompleted)
    }
    
    func testCreateNewTask() {
        let newTask = TodoItem(
            id: Int.random(in: 1000...9999),
            title: "New task",
            isCompleted: false,
            userId: 1,
            description: "Task description"
        )
        
        XCTAssertTrue(newTask.id >= 1000 && newTask.id <= 9999)
        XCTAssertEqual(newTask.title, "New task")
        XCTAssertFalse(newTask.isCompleted)
        XCTAssertEqual(newTask.userId, 1)
        XCTAssertEqual(newTask.description, "Task description")
    }
    
    func testEditTask() {
        let originalTask = TodoItem(id: 1, title: "Original title")
        
        let editedTask = TodoItem(
            id: originalTask.id,
            title: "Updated title",
            isCompleted: true,
            userId: originalTask.userId,
            description: "Updated description"
        )
        
        XCTAssertEqual(editedTask.id, 1)
        XCTAssertEqual(editedTask.title, "Updated title")
        XCTAssertTrue(editedTask.isCompleted)
        XCTAssertEqual(editedTask.description, "Updated description")
    }
    
    func testSearchFunctionality() {
        let tasks = [
            TodoItem(id: 1, title: "Buy groceries", description: "Milk and eggs"),
            TodoItem(id: 2, title: "Call mom", description: "Birthday call"),
            TodoItem(id: 3, title: "Finish work", description: "Project deadline")
        ]
        
        let searchTerm = "mom"
        let filteredTasks = tasks.filter { task in
            task.title.lowercased().contains(searchTerm.lowercased()) ||
            (task.description?.lowercased().contains(searchTerm.lowercased()) ?? false)
        }
        
        XCTAssertEqual(filteredTasks.count, 1)
        XCTAssertEqual(filteredTasks.first?.title, "Call mom")
    }

    func testExample() throws {
    }

    func testPerformanceExample() throws {
    }
}
