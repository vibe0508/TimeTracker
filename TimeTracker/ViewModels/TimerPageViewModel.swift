//
//  TimerPageViewModel.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import Foundation
import Combine
import SwiftUI

final class TimerPageViewModel: ObservableObject {
    @Published
    private(set) var timerText = ""

    var showCompletedView: AnyPublisher<(), Never> {
        timerStateManager.finishedTimers
            .map { _ in }
            .eraseToAnyPublisher()
    }

    @Published
    private(set) var buttonTitle = ""

    @Published
    private(set) var comment = ""

    var commentBinding: Binding<String> {
        Binding(
            get: { [weak self] in self?.comment ?? "" },
            set: { [timerStateManager] in timerStateManager.updateComment($0) }
        )
    }

    private let timeFormatter: TimeFormatter
    private let timerStateManager: TimerStateManager
    private let timeEntryRepository: TimeEntryRepository

    @Published
    private var onButtonStartTimer = true

    private var cancellables: Set<AnyCancellable> = []

    init(
        timeFormatter: TimeFormatter,
        timerStateManager: TimerStateManager,
        timeEntryRepository: TimeEntryRepository
    ) {
        self.timeFormatter = timeFormatter
        self.timerStateManager = timerStateManager
        self.timeEntryRepository = timeEntryRepository

        setupBindings()
    }

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    func onButtonTap() {
        if onButtonStartTimer {
            timerStateManager.startTimer()
        } else {
            timerStateManager.stopTimer()
        }
    }

    private func setupBindings() {
        timerStateManager.finishedTimers
            .sink(receiveValue: { [timeEntryRepository] finishedState in
                timeEntryRepository.addEntry(
                    startDate: finishedState.startDate,
                    endDate: finishedState.endDate,
                    comment: finishedState.comment
                )
            })
            .store(in: &cancellables)

        timerStateManager.timerStatus
            .map {
                switch $0 {
                case .inProgress:
                    return false
                default:
                    return true
                }
            }
            .assign(to: &$onButtonStartTimer)

        timerStateManager.timerStatus
            .map { status -> AnyPublisher<(Date, Date), Never> in
                switch status {
                case .notStarted:
                    return Just((Date(), Date())).eraseToAnyPublisher()
                case .inProgress(let startDate):
                    return Timer
                        .publish(every: 1, on: .main, in: .default)
                        .autoconnect()
                        .prepend(startDate)
                        .map { (startDate, $0) }
                        .eraseToAnyPublisher()
                case .finished(let startDate, let endDate):
                    return Just((startDate, endDate)).eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .map { [timeFormatter] (startDate: Date, endDate: Date) in
                timeFormatter.timeString(startDate: startDate, endDate: endDate)
            }
            .assign(to: &$timerText)

        timerStateManager.timerStatus
            .map {
                switch $0 {
                case .notStarted:
                    return "Start"

                case .inProgress:
                    return "Stop"

                case .finished:
                    return ""
                }
            }
            .assign(to: &$buttonTitle)

        timerStateManager
            .comment
            .map { $0 ?? "" }
            .assign(to: &$comment)
    }
}
