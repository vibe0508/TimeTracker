//
//  TimeEntryRepositoryMock.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
@testable import TimeTracker

final class TimeEntryRepositoryMock: TimeEntryRepository {
    var savedParams: (Date, Date, String?)?
    var entryToRemove: TimeEntry?
    var returnEntries: [TimeEntry] = []

    func addEntry(startDate: Date, endDate: Date, comment: String?) -> TimeEntry {
        savedParams = (startDate, endDate, comment)
        return TimeEntry(id: .init(), startDate: startDate, endDate: endDate, comment: comment)
    }

    func removeEntry(_ timeEntry: TimeEntry) {
        entryToRemove = timeEntry
    }

    func getEntries() -> [TimeEntry] {
        returnEntries
    }
}
