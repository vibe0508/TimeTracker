//
//  DateFormatterMock.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
@testable import TimeTracker

final class DateFormatterMock: TimeTracker.DateFormatter {
    var lastDate: Date?

    func string(from date: Date) -> String {
        lastDate = date
        return "MOCK DATE"
    }
}
