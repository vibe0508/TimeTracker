//
//  TimeFormatterTests.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import Foundation
import XCTest
@testable import TimeTracker

class TimeFormatterTests: XCTestCase {
    var timeFormatter: TimeFormatterImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()

        timeFormatter = TimeFormatterImpl()
    }

    func testNoDays() {
        let startDate = Date()
        let endDate = Date(timeIntervalSinceNow: 10*60*60 + 15*60 + 28)

        let resultString = timeFormatter.timeString(startDate: startDate, endDate: endDate)

        XCTAssertEqual(resultString, "10:15:28")
    }

    func testDays() {
        let startDate = Date()
        let endDate = Date(timeIntervalSinceNow: 10*24*60*60)

        let resultString = timeFormatter.timeString(startDate: startDate, endDate: endDate)

        XCTAssertEqual(resultString, "10:00:00:00")
    }

    func testOneDigit() {
        let startDate = Date()
        let endDate = Date(timeIntervalSinceNow: 1*60*60 + 2*60 + 3)

        let resultString = timeFormatter.timeString(startDate: startDate, endDate: endDate)

        XCTAssertEqual(resultString, "01:02:03")
    }
}
