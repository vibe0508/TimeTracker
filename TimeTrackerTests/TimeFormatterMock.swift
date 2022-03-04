//
//  TimeFormatterMock.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
@testable import TimeTracker

final class TimeFormatterMock: TimeFormatter {
    var receivedStartDate: Date?
    var receivedEndDate: Date?

    func timeString(startDate: Date, endDate: Date) -> String {
        receivedStartDate = startDate
        receivedEndDate = endDate

        return "MOCK"
    }
}
