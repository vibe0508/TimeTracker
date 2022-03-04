//
//  TimeEntryRepositoryMock.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
import Combine
@testable import TimeTracker

final class TimeEntryRepositoryMock: TimeEntryRepository {
    var savedParams: (Date, Date, String?)?
    var entryToRemove: TimeEntry?

    @Published
    var entries: [TimeEntry] = []

    var entriesPublisher: AnyPublisher<[TimeEntry], Never> {
        $entries.eraseToAnyPublisher()
    }

    func addEntry(startDate: Date, endDate: Date, comment: String?) -> TimeEntry {
        savedParams = (startDate, endDate, comment)
        return TimeEntry(id: .init(), startDate: startDate, endDate: endDate, comment: comment)
    }

    func removeEntry(_ timeEntry: TimeEntry) {
        entryToRemove = timeEntry
    }
}
