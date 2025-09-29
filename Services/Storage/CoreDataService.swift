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
    
    func saveTodos(_ todos: [TodoItem]) {
        print("Saving \(todos.count) todos to CoreData")
        
        deleteAllTodos()
        
        for todo in todos {
            let entity = NSEntityDescription.insertNewObject(forEntityName: "TodoEntity", into: context)
            entity.setValue(Int64(todo.id), forKey: "id")
            entity.setValue(todo.title, forKey: "title")
            entity.setValue(todo.isCompleted, forKey: "isCompleted")
            entity.setValue(Int64(todo.userId), forKey: "userId")
            entity.setValue(todo.createdAt, forKey: "createdAt")
            entity.setValue(todo.description, forKey: "taskDescription")
        }
        
        saveContext()
    }
    
    func loadTodos() -> [TodoItem] {
        print("Loading todos from CoreData")
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "TodoEntity")
        
        do {
            let results = try context.fetch(request)
            var todos: [TodoItem] = []
            
            for case let entity as NSManagedObject in results {
                let id = entity.value(forKey: "id") as? Int64 ?? 0
                let title = entity.value(forKey: "title") as? String ?? ""
                let isCompleted = entity.value(forKey: "isCompleted") as? Bool ?? false
                let userId = entity.value(forKey: "userId") as? Int64 ?? 0
                let createdAt = entity.value(forKey: "createdAt") as? Date ?? Date()
                let description = entity.value(forKey: "taskDescription") as? String
                
                var todo = TodoItem(
                    id: Int(id),
                    title: title,
                    isCompleted: isCompleted,
                    userId: Int(userId),
                    description: description)
                
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
    
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
            print("CoreData: Saved successfully")
        } catch {
            print("CoreData: Error saving - \(error)")
        }
    }
}
