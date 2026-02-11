//
//  File.swift
//  MyLibrary
//
//  Created by Abdullaev Bekzod on 25/01/25.
//

import CoreData

public class DataManager:@unchecked Sendable {
    static public let shared = DataManager()
    var needUpdate = false
    var hasLocalDelete = false
   
    lazy private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores { (storeDestination, error) in
            if let err = error as NSError? {
                print("Unresolved error \(err), \(err.userInfo)")
            }
        }
        return container
    }()
    
    lazy var context: NSManagedObjectContext = {
        getContex()
    }()
    
    private init() { }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contextDidChange(notification:)),
            name: NSNotification.Name.NSManagedObjectContextObjectsDidChange,
            object: getContex())
    }
    
    @objc private func contextDidChange(notification: NSNotification) {
        // Extract inserted, updated, and deleted objects from the notification
        let insertedObjects = notification.userInfo?[NSInsertedObjectsKey] as? Set<NSManagedObject> ?? []
        let updatedObjects = notification.userInfo?[NSUpdatedObjectsKey] as? Set<NSManagedObject> ?? []
        let deletedObjects = notification.userInfo?[NSDeletedObjectsKey] as? Set<NSManagedObject> ?? []
        
    }
    
    private func getContex() -> NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    public func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    public func deleteAllData(isLogout: Bool = false) {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else { return }
        for entity in model.entities {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name ?? "")
            request.includesPropertyValues = false
            
            deleteAllDataOfEntitiy(entityName: entity)
            
            hasLocalDelete = true
        }
    }
    
    public func deleteAllDataOfEntitiy(entityName entity: NSEntityDescription) {
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity.name ?? "")
            let objects = try context.fetch(request) as? [NSManagedObject]
            
            for object in objects ?? [] {
                context.delete(object)
            }
            
            save()
            print("All data of \(entity.name ?? "") entity deleted successfully.")
        } catch {
            print("Failed to delete data of \(entity.name ?? "") entity: \(error)")
        }
    }
}




