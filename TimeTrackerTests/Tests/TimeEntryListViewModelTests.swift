//
//  TimeEntryListViewModelTests.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
import XCTest
@testable import TimeTracker

class TimeEntryListViewModelTests: XCTestCase {
    var repositoryMock: TimeEntryRepositoryMock!
    var timeFormatterMock: TimeFormatterMock!
    var dateFormatterMock: DateFormatterMock!

    var viewModel: TimeEntryListViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        repositoryMock = .init()
        timeFormatterMock = .init()
        dateFormatterMock = .init()

        viewModel = .init(
            repository: repositoryMock,
            timeFormatter: timeFormatterMock,
            dateFormatter: dateFormatterMock
        )
    }

    func testMapping() {
        let comment = UUID().uuidString
        let id1 = UUID()
        let id2 = UUID()
        let date2 = Date(timeIntervalSinceNow: 300)

        repositoryMock.entries = [
            TimeEntry(
                id: id1,
                startDate: Date(),
                endDate: Date(timeIntervalSinceNow: 200),
                comment: comment
            ),

            TimeEntry(
                id: id2,
                startDate: date2,
                endDate: Date(timeIntervalSinceNow: 400),
                comment: nil
            )
        ]

        let expectedEntries: [TimeEntriesListView.Entry] = [
            .init(id: id1, date: "MOCK DATE", duration: "MOCK", comment: comment),
            .init(id: id2, date: "MOCK DATE", duration: "MOCK", comment: nil)
        ]

        XCTAssertEqual(viewModel.entries, expectedEntries)
        XCTAssertEqual(dateFormatterMock.lastDate, date2)
    }

    func testDelete() {
        repositoryMock.entries = [
            TimeEntry(
                id: UUID(),
                startDate: Date(),
                endDate: Date(timeIntervalSinceNow: 200),
                comment: nil
            ),

            TimeEntry(
                id: UUID(),
                startDate: Date(timeIntervalSinceNow: 300),
                endDate: Date(timeIntervalSinceNow: 400),
                comment: nil
            )
        ]

        viewModel.delete(at: [1])

        XCTAssertEqual(repositoryMock.entryToRemove, repositoryMock.entries.last)
    }
}
