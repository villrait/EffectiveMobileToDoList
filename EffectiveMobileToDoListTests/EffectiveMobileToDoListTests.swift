//
//  EffectiveMobileToDoListTests.swift
//  EffectiveMobileToDoListTests
//
//  Created by м on 25.09.2025.
//

import XCTest
@testable import EffectiveMobileToDoList

final class EffectiveMobileToDoListTests: XCTestCase {

    // MARK: - TodoItem Tests
    
    func testTodoItemCreation() {
        // Given
        let task = TodoItem(
            id: 1,
            title: "Купить молоко",
            isCompleted: false,
            userId: 123,
            description: "Не забыть купить молоко"
        )
        
        // Then
        XCTAssertEqual(task.id, 1)
        XCTAssertEqual(task.title, "Купить молоко")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.userId, 123)
        XCTAssertEqual(task.description, "Не забыть купить молоко")
    }
    
    func testTodoItemDefaultValues() {
        // Given
        let task = TodoItem(id: 2, title: "Простая задача")
        
        // Then
        XCTAssertEqual(task.id, 2)
        XCTAssertEqual(task.title, "Простая задача")
        XCTAssertFalse(task.isCompleted)
        XCTAssertEqual(task.userId, 1)
        XCTAssertNil(task.description)
    }
    
    func testTodoItemCompletionToggle() {
        // Given
        var task = TodoItem(id: 3, title: "Задача")
        
        // When
        let completedTask = TodoItem(
            id: task.id,
            title: task.title,
            isCompleted: true,
            userId: task.userId,
            description: task.description
        )
        
        // Then
        XCTAssertTrue(completedTask.isCompleted)
    }

    func testExample() throws {
        
    }

    func testPerformanceExample() throws {
        
    }
}
