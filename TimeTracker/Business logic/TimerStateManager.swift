//
//  TimerStateManager.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import Combine
import Foundation

protocol TimerStateManager {
    var comment: AnyPublisher<String?, Never> { get }
    var timerStatus: AnyPublisher<TimerStatus, Never> { get }
    var finishedTimers: AnyPublisher<TimerFinishedState, Never> { get }

    func updateComment(_ comment: String?)
    func startTimer()
    func stopTimer()
}

final class TimerStateManagerImpl: TimerStateManager {
    var comment: AnyPublisher<String?, Never> {
        $commentPrivate.eraseToAnyPublisher()
    }

    var timerStatus: AnyPublisher<TimerStatus, Never> {
        $timerStatusPrivate.eraseToAnyPublisher()
    }

    var finishedTimers: AnyPublisher<TimerFinishedState, Never> {
        finishedTimersSubject.eraseToAnyPublisher()
    }

    @Published
    private var commentPrivate: String?

    @Published
    private var timerStatusPrivate: TimerStatus = .notStarted

    private let finishedTimersSubject = PassthroughSubject<TimerFinishedState, Never>()

    private var finishWorkItem: DispatchWorkItem?

    func updateComment(_ comment: String?) {
        commentPrivate = comment

        if finishWorkItem != nil {
            scheduleFinish()
        }
    }

    func startTimer() {
        timerStatusPrivate = .inProgress(startDate: Date())
    }

    func stopTimer() {
        guard case let .inProgress(startDate) = timerStatusPrivate else {
            assertionFailure()
            return
        }

        timerStatusPrivate = .finished(startDate: startDate, endDate: Date())
        scheduleFinish()
    }

    private func scheduleFinish() {
        finishWorkItem?.cancel()

        let finishWorkItem = DispatchWorkItem { [weak self] in
            self?.finish()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: finishWorkItem)
        self.finishWorkItem = finishWorkItem
    }

    private func finish() {
        finishWorkItem = nil
        
        guard case let .finished(startDate, endDate) = timerStatusPrivate else {
            assertionFailure()
            return
        }

        finishedTimersSubject.send(
            .init(
                startDate: startDate,
                endDate: endDate,
                comment: commentPrivate
            )
        )
        commentPrivate = nil
        timerStatusPrivate = .notStarted
    }
}
