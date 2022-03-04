//
//  CoreDataAssembly.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import CoreData

final class CoreDataAssembly {
    private let persistentContainer = NSPersistentContainer(name: "Model")

    init() {
        let lock = NSRecursiveLock()
        lock.lock()
        persistentContainer.loadPersistentStores(completionHandler: { _, _ in lock.unlock() })

        lock.lock() // Wait for stores to be loaded
        lock.unlock()
    }

    func makeManagedObjectContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}
