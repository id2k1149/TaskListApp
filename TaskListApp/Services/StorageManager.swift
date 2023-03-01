//
//  StorageManager.swift
//  TaskListApp
//
//  Created by Max Franz Immelmann on 3/1/23.
//

import CoreData

final class StorageManager {
    static let shared = StorageManager()
    private init(){}
    
    // MARK: - Core Data stack
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskListApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving Context
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Core Data Delete Context
    func deleteTask(_ task: Task) {
            let context = persistentContainer.viewContext
            context.delete(task)
            saveContext()
        }
}
