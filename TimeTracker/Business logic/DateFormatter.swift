//
//  DateFormatter.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation

protocol DateFormatter {
    func string(from date: Date) -> String
}

final class DateFormatterImpl: DateFormatter {
    private let todayFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "H:mm"
        return formatter
    }()

    private let regularFormatter: Foundation.DateFormatter = {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()

    func string(from date: Date) -> String {
        Calendar.current.isDateInToday(date)
        ? todayFormatter.string(from: date)
        : regularFormatter.string(from: date)
    }
}
