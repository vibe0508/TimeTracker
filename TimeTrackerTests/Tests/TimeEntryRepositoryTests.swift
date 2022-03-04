//
//  TimeEntryRepositoryTests.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import XCTest
import CoreData
@testable import TimeTracker

class TimeEntryRepositoryTests: XCTestCase {
    lazy var rootManagedObjectContext = NSPersistentContainer(name: "Model").viewContext

    var managedObjectContext: NSManagedObjectContext!
    var repository: TimeEntryRepositoryImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()

        rootManagedObjectContext.reset()
        managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.parent = rootManagedObjectContext
        repository = TimeEntryRepositoryImpl(managedObjectContext: managedObjectContext)
    }

    func testItemCreationWithoutComment() {
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: 1100)

        let createdEntity = repository.addEntry(startDate: startDate, endDate: endDate, comment: nil)
        let fetchedEntity = repository.entries.first

        XCTAssertEqual(startDate, createdEntity.startDate)
        XCTAssertEqual(endDate, createdEntity.endDate)
        XCTAssertNil(createdEntity.comment)
        XCTAssertEqual(createdEntity.id, fetchedEntity?.id)
    }

    func testItemCreationWithComment() {
        let startDate = Date(timeIntervalSince1970: 0)
        let endDate = Date(timeIntervalSince1970: 1100)
        let comment = UUID().uuidString

        let createdEntity = repository.addEntry(startDate: startDate, endDate: endDate, comment: comment)

        XCTAssertEqual(createdEntity.comment, comment)
    }

    func testDeletion() {
        let firstEntry = repository.addEntry(startDate: Date(), endDate: Date(timeIntervalSinceNow: 20), comment: nil)
        repository.addEntry(startDate: Date(), endDate: Date(timeIntervalSinceNow: 20), comment: nil)

        repository.removeEntry(firstEntry)

        let remainingEntries = repository.entries

        XCTAssertEqual(remainingEntries.count, 1)
        XCTAssertNotEqual(remainingEntries.first?.id, firstEntry.id)
    }

    func testFetch() {
        let data: [(Date, Date, String?)] = [
            (Date(timeIntervalSinceNow: 2560), Date(timeIntervalSinceNow: 5000), UUID().uuidString),
            (Date(timeIntervalSinceNow: 1450), Date(timeIntervalSinceNow: 2000), UUID().uuidString),
            (Date(timeIntervalSinceNow: 120), Date(timeIntervalSinceNow: 1000), UUID().uuidString),
            (Date(timeIntervalSinceNow: 0), Date(timeIntervalSinceNow: 100), nil)
        ]

        let createdEntries = data.map {
            repository.addEntry(startDate: $0, endDate: $1, comment: $2)
        }

        repository = TimeEntryRepositoryImpl(managedObjectContext: managedObjectContext)

        let fetchedEntries = repository.entries

        XCTAssertEqual(createdEntries, fetchedEntries)
    }
}
