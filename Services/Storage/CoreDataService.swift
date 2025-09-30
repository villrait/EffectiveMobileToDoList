//
//  CoreDataService.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation
import CoreData

class CoreDataService: StorageServiceProtocol {
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "EffectiveMobileToDoList")
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var isFirstLaunch: Bool {
        get { !UserDefaults.standard.bool(forKey: "isDataLoaded") }
        set { UserDefaults.standard.set(!newValue, forKey: "isDataLoaded") }
    }
    
    
    func saveNewTaskOnly(_ task: TodoItem) {
        print("Saving ONLY ONE new task: \(task.title)")
        saveNewTask(task)
        saveContext()
    }
    
    func updateTaskCompletion(_ task: TodoItem, isCompleted: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first as? NSManagedObject {
                entity.setValue(isCompleted, forKey: "isCompleted")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                let updatedAt = entity.value(forKey: "updatedAt") as? Date ?? Date()
                print("UPDATING Completion: '\(task.title)' - \(isCompleted), keeping update date: \(formatter.string(from: updatedAt))")
            }
            saveContext()
        } catch {
            print("CoreData: Error updating task completion - \(error)")
        }
    }
    
    func updateTaskOnly(_ task: TodoItem) {
        print("✏️ Обновление задачи '\(task.title)' в Core Data, поток: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first as? NSManagedObject {
                entity.setValue(task.title, forKey: "title")
                entity.setValue(task.isCompleted, forKey: "isCompleted")
                entity.setValue(task.description, forKey: "taskDescription")
                entity.setValue(Date(), forKey: "updatedAt")
                
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm:ss"
                print("UPDATING Task: '\(task.title)' - Updated at: \(formatter.string(from: Date()))")
            }
            saveContext()
        } catch {
            print("CoreData: Error updating task - \(error)")
        }
    }
    
    func saveTodos(_ todos: [TodoItem]) {
        print("💾 Сохранение \(todos.count) задач в Core Data, поток: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
        
        if isFirstLaunch {
            print("First launch - saving API tasks with old dates")
            deleteAllTodos()
            
            for todo in todos {
                let oldDate = Calendar.current.date(byAdding: .day, value: -Int.random(in: 1...30), to: Date())!
                saveTaskWithDate(todo, date: oldDate)
            }
            
            isFirstLaunch = false
        } else {
            print("Full replace - saving all tasks with current dates")
            deleteAllTodos()
            for todo in todos {
                saveNewTask(todo)
            }
        }
        
        saveContext()
    }
    
    func loadTodos() -> [TodoItem] {
        print("Loading todos from CoreData")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        
        // Сортируем по updatedAt (времени обновления) - новые сверху
        let sortByUpdateDate = NSSortDescriptor(key: "updatedAt", ascending: false)
        request.sortDescriptors = [sortByUpdateDate]
        
        do {
            let results = try context.fetch(request)
            var todos: [TodoItem] = []
            
            for case let entity as NSManagedObject in results {
                let id = entity.value(forKey: "id") as? Int64 ?? 0
                let title = entity.value(forKey: "title") as? String ?? ""
                let isCompleted = entity.value(forKey: "isCompleted") as? Bool ?? false
                let userId = entity.value(forKey: "userId") as? Int64 ?? 0
                let createdAt = entity.value(forKey: "createdAt") as? Date ?? Date()
                let updatedAt = entity.value(forKey: "updatedAt") as? Date ?? Date()  // Добавляем чтение updatedAt
                let description = entity.value(forKey: "taskDescription") as? String
                
                let todo = TodoItem(
                    id: Int(id),
                    title: title,
                    isCompleted: isCompleted,
                    userId: Int(userId),
                    description: description
                )
                
                todos.append(todo)
            }
            
            return todos
        } catch {
            print("CoreData: Error loading - \(error)")
            return []
        }
    }
    
    private func deleteAllTodos() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print("CoreData: Error deleting - \(error)")
        }
    }
    
    private func deleteTask(with id: Int) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try context.fetch(request)
            for case let entity as NSManagedObject in results {
                context.delete(entity)
            }
        } catch {
            print("CoreData: Error deleting task - \(error)")
        }
    }
    
    private func saveTaskWithDate(_ task: TodoItem, date: Date) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "TodoEntity", into: context)
        entity.setValue(Int64(task.id), forKey: "id")
        entity.setValue(task.title, forKey: "title")
        entity.setValue(task.isCompleted, forKey: "isCompleted")
        entity.setValue(Int64(task.userId), forKey: "userId")
        entity.setValue(date, forKey: "createdAt")
        entity.setValue(date, forKey: "updatedAt")
        entity.setValue(task.description, forKey: "taskDescription")
    }

    private func saveNewTask(_ task: TodoItem) {
        let entity = NSEntityDescription.insertNewObject(forEntityName: "TodoEntity", into: context)
        entity.setValue(Int64(task.id), forKey: "id")
        entity.setValue(task.title, forKey: "title")
        entity.setValue(task.isCompleted, forKey: "isCompleted")
        entity.setValue(Int64(task.userId), forKey: "userId")
        let currentDate = Date()
        entity.setValue(currentDate, forKey: "createdAt")
        entity.setValue(currentDate, forKey: "updatedAt")
        entity.setValue(task.description, forKey: "taskDescription")
    }
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            print("CoreData: Saved successfully")
        } catch {
            print("CoreData: Error saving - \(error)")
        }
    }

    func deleteTask(_ task: TodoItem) {
        print("🗑️ Удаление задачи '\(task.title)' из Core Data, поток: \(Thread.isMainThread ? "MAIN" : "BACKGROUND")")
        deleteTask(with: task.id)
        saveContext()
    }
}
