//
//  TimerStateManagerMock.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
import Combine
@testable import TimeTracker

final class TimerStateManagerMock: TimerStateManager {
    var comment: AnyPublisher<String?, Never> {
        commentSubject.eraseToAnyPublisher()
    }

    var timerStatus: AnyPublisher<TimerStatus, Never> {
        timerStatusSubject.eraseToAnyPublisher()
    }

    var finishedTimers: AnyPublisher<TimerFinishedState, Never> {
        finishedTimersSubject.eraseToAnyPublisher()
    }

    let commentSubject = PassthroughSubject<String?, Never>()
    let timerStatusSubject = PassthroughSubject<TimerStatus, Never>()
    let finishedTimersSubject = PassthroughSubject<TimerFinishedState, Never>()

    var startTimerCalled = false
    var stopTimerCalled = false
    var updatedComment: String?

    func updateComment(_ comment: String?) {
        updatedComment = comment
    }

    func startTimer() {
        startTimerCalled = true
    }

    func stopTimer() {
        stopTimerCalled = true
    }
}
