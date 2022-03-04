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
    func string(from date: Date) -> String {
        "BUM!"
    }
}
