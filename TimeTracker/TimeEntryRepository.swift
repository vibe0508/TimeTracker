//
//  TimeEntryRepository.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 02.03.2022.
//

import Foundation
import CoreData

protocol TimeEntryRepository {
    @discardableResult
    func addEntry(startDate: Date, endDate: Date, comment: String?) -> TimeEntry

    func removeEntry(_ timeEntry: TimeEntry)

    func getEntries() -> [TimeEntry]
}

final class TimeEntryRepositoryImpl: TimeEntryRepository {
    private let managedObjectContext: NSManagedObjectContext

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    @discardableResult
    func addEntry(startDate: Date, endDate: Date, comment: String?) -> TimeEntry {
        let id = UUID()

        let storedEntry = StoredTimeEntry(context: managedObjectContext)
        storedEntry.id = id
        storedEntry.startDate = startDate
        storedEntry.endDate = endDate
        storedEntry.comment = comment

        do {
            try managedObjectContext.save()
        } catch {
            print("Error saving context: \(error)")
        }

        return TimeEntry(
            id: id,
            startDate: startDate,
            endDate: endDate,
            comment: comment
        )
    }

    func removeEntry(_ timeEntry: TimeEntry) {
        let predicate = NSPredicate(format: "id = %@", timeEntry.id as CVarArg)
        let fetchRequest = StoredTimeEntry.fetchRequest()
        fetchRequest.predicate = predicate

        managedObjectContext.performAndWait { [weak managedObjectContext] in
            do {
                guard let storedEntry = try fetchRequest.execute().first else {
                    return
                }

                managedObjectContext?.delete(storedEntry)
            } catch {
                print("Can't find time entry: \(timeEntry)")
            }
        }
    }

    func getEntries() -> [TimeEntry] {
        let fetchRequest = StoredTimeEntry.fetchRequest()
        fetchRequest.sortDescriptors = [.init(keyPath: \StoredTimeEntry.startDate, ascending: false)]

        var timeEntries: [TimeEntry] = []

        managedObjectContext.performAndWait {
            do {
                timeEntries = try fetchRequest.execute().compactMap {
                    guard let id = $0.id, let startDate = $0.startDate, let endDate = $0.endDate else {
                        return nil
                    }

                    return TimeEntry(
                        id: id,
                        startDate: startDate,
                        endDate: endDate,
                        comment: $0.comment
                    )
                }
            } catch {
                print("Can't fetch time entries with error: \(error)")
            }
        }

        return timeEntries
    }
}
