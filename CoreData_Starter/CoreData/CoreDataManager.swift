//
//  CoreDataManager.swift
//  CoreData_Starter
//
//  Created by Swain Yun on 12/16/23.
//

import Foundation
import CoreData

final class CoreDataManager {
    // MARK: Singleton
    static let shared = CoreDataManager()
    
    // MARK: Properties
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        CoreDataManager.shared.persistentContainer.viewContext
    }
    
    // MARK: Life Cycle
    private init() {}
    
    // MARK: Public
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? context
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func fetchData<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T] {
        do {
            let fetchResult = try context.fetch(request)
            return fetchResult
        } catch {
            print("Failed to fetch Models from context")
            return []
        }
    }
}
