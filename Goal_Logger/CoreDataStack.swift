//
//  CoreDataStack.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-17.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import Foundation
import CoreData


class CoreDataStack {
    private let modelName: String
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved Error, \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    func saveContext() {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved Error \(error), \(error.userInfo)")
        }
    }
}
