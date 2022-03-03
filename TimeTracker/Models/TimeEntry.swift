//
//  TimeEntry.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 02.03.2022.
//

import Foundation

struct TimeEntry: Equatable {
    let id: UUID
    let startDate: Date
    let endDate: Date
    let comment: String?

    var duration: TimeInterval {
        endDate.timeIntervalSince(startDate)
    }
}
