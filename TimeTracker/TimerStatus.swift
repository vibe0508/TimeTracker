//
//  TimerStatus.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import Foundation

enum TimerStatus: Equatable {
    case notStarted
    case inProgress(startDate: Date)
    case finished(startDate: Date, endDate: Date)
}
