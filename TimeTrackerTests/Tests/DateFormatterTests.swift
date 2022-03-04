//
//  DateFormatterTests.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
import XCTest
@testable import TimeTracker

class DateFormatterTests: XCTestCase {
    var dateFormatter: DateFormatterImpl!

    override func setUpWithError() throws {
        try super.setUpWithError()

        NSTimeZone.default = .init(secondsFromGMT: 0) ?? .current
        dateFormatter = DateFormatterImpl()
    }

    func testToday() {
        let date = Calendar.current.startOfDay(for: Date()) + 9*3600 + 5*60

        XCTAssertEqual(dateFormatter.string(from: date), "9:05")
    }

    func testFarAway() {
        let date = Date(timeIntervalSince1970: 952168429)

        XCTAssertEqual(dateFormatter.string(from: date), "4 Mar")
    }
}
