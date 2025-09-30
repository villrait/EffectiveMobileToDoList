//
//  CoreDataService.swift
//  EffectiveMobileToDoList
//
//  Created by м on 25.09.2025.
//

import Foundation
import CoreData

class CoreDataService: StorageServiceProtocol {
    
    // MARK: - Properties
    
    private let persistentContainer: NSPersistentContainer
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private var isFirstLaunch: Bool {
        get { !UserDefaults.standard.bool(forKey: "isDataLoaded") }
        set { UserDefaults.standard.set(!newValue, forKey: "isDataLoaded") }
    }
    
    // MARK: - Initialization
    
    init() {
        persistentContainer = NSPersistentContainer(name: "EffectiveMobileToDoList")
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Private Methods
    // MARK: Core Data Operations
    
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
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("CoreData: Error saving - \(error)")
        }
    }
    
    // MARK: - Public Methods
    // MARK: Save Operations
    
    func saveTodos(_ todos: [TodoItem]) {
        if isFirstLaunch {
            deleteAllTodos()
            
            for todo in todos {
                let oldDate = Calendar.current.date(byAdding: .day, value: -Int.random(in: 1...30), to: Date())!
                saveTaskWithDate(todo, date: oldDate)
            }
            
            isFirstLaunch = false
        } else {
            deleteAllTodos()
            for todo in todos {
                saveNewTask(todo)
            }
        }
        
        saveContext()
    }
    
    func saveNewTaskOnly(_ task: TodoItem) {
        saveNewTask(task)
        saveContext()
    }
    
    // MARK: Update Operations
    
    func updateTaskOnly(_ task: TodoItem) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first as? NSManagedObject {
                entity.setValue(task.title, forKey: "title")
                entity.setValue(task.isCompleted, forKey: "isCompleted")
                entity.setValue(task.description, forKey: "taskDescription")
                entity.setValue(Date(), forKey: "updatedAt")
            }
            saveContext()
        } catch {
            print("CoreData: Error updating task - \(error)")
        }
    }
    
    func updateTaskCompletion(_ task: TodoItem, isCompleted: Bool) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        request.predicate = NSPredicate(format: "id == %d", task.id)
        
        do {
            let results = try context.fetch(request)
            if let entity = results.first as? NSManagedObject {
                entity.setValue(isCompleted, forKey: "isCompleted")
            }
            saveContext()
        } catch {
            print("CoreData: Error updating task completion - \(error)")
        }
    }
    
    // MARK: Read Operations
    
    func loadTodos() -> [TodoItem] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
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
                let updatedAt = entity.value(forKey: "updatedAt") as? Date ?? Date()
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
    
    // MARK: Delete Operations
    
    func deleteTask(_ task: TodoItem) {
        deleteTask(with: task.id)
        saveContext()
    }

}
