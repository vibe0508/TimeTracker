//
//  TimeFormatter.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import Foundation

protocol TimeFormatter {
    func timeString(startDate: Date, endDate: Date) -> String
}

final class TimeFormatterImpl: TimeFormatter {
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 2
        formatter.maximumIntegerDigits = 2
        return formatter
    }()

    func timeString(startDate: Date, endDate: Date) -> String {
        let components = Calendar.current.dateComponents(
            [.day, .hour, .minute, .second],
            from: startDate,
            to: endDate
        )

        let daysString = components.day.flatMap { $0 > 0 ? "\(numberString(for: $0)):" : nil } ?? ""
        let mainString = "\(numberString(for: components.hour)):\(numberString(for: components.minute)):\(numberString(for: components.second))"

        return daysString + mainString
    }
    
    private func numberString(for integer: Int?) -> String {
        integer.flatMap { numberFormatter.string(from: $0 as NSNumber) } ?? ""
    }
}
