//
//  TimerPageViewModelTests.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import Foundation
import XCTest
import Combine
@testable import TimeTracker

class TimerPageViewModelTests: XCTestCase {
    var timeFormatterMock: TimeFormatterMock!
    var repositoryMock: TimeEntryRepositoryMock!
    var stateManagerMock: TimerStateManagerMock!

    var viewModel: TimerPageViewModel!

    var cancellables: Set<AnyCancellable> = []

    override func setUpWithError() throws {
        try super.setUpWithError()

        timeFormatterMock = TimeFormatterMock()
        repositoryMock = TimeEntryRepositoryMock()
        stateManagerMock = TimerStateManagerMock()

        viewModel = TimerPageViewModel(
            timeFormatter: timeFormatterMock,
            timerStateManager: stateManagerMock,
            timeEntryRepository: repositoryMock
        )
    }

    func testNotStarted() {
        stateManagerMock.timerStatusSubject.send(.notStarted)

        XCTAssertEqual(viewModel.timerText, "MOCK")
        XCTAssertEqual(timeFormatterMock.receivedStartDate, timeFormatterMock.receivedEndDate)
        XCTAssertEqual(viewModel.buttonTitle, "Start")
        XCTAssertNil(repositoryMock.savedParams)
    }

    func testInProgress() {
        let timerFired = expectation(description: "Timer fired")
        let startDate = Date()

        viewModel.$timerText
            .filter { !$0.isEmpty }
            .sink(receiveValue: {
                XCTAssertEqual($0, "MOCK")
                timerFired.fulfill()
            })
            .store(in: &cancellables)

        stateManagerMock.timerStatusSubject.send(.inProgress(startDate: startDate))

        waitForExpectations(timeout: 0.05) { [self] _ in
            XCTAssertEqual(timeFormatterMock.receivedStartDate, startDate)
            XCTAssertEqual(timeFormatterMock.receivedEndDate, startDate)
            XCTAssertEqual(viewModel.buttonTitle, "Stop")
            XCTAssertNil(repositoryMock.savedParams)
        }
    }

    func testFinished() {
        let startDate = Date()
        let endDate = startDate + 3

        stateManagerMock.timerStatusSubject.send(.finished(startDate: startDate, endDate: endDate))

        XCTAssertEqual(viewModel.timerText, "MOCK")
        XCTAssertEqual(timeFormatterMock.receivedStartDate, startDate)
        XCTAssertEqual(timeFormatterMock.receivedEndDate, endDate)
        XCTAssertEqual(viewModel.buttonTitle, "")
        XCTAssertNil(repositoryMock.savedParams)
    }

    func testStartTimer() {
        stateManagerMock.timerStatusSubject.send(.notStarted)

        viewModel.onButtonTap()

        XCTAssert(stateManagerMock.startTimerCalled)
        XCTAssertFalse(stateManagerMock.stopTimerCalled)
    }

    func testStopTimer() {
        stateManagerMock.timerStatusSubject.send(.inProgress(startDate: Date()))

        viewModel.onButtonTap()

        XCTAssert(stateManagerMock.stopTimerCalled)
        XCTAssertFalse(stateManagerMock.startTimerCalled)
    }

    func testTimerSave() {
        let showCompletedViewCalled = expectation(description: "showCompletedViewCalled")
        let finishedState = TimerFinishedState(
            startDate: Date(),
            endDate: Date(timeIntervalSinceNow: 220),
            comment: UUID().uuidString
        )

        viewModel.showCompletedView
            .sink(receiveValue: showCompletedViewCalled.fulfill)
            .store(in: &cancellables)

        stateManagerMock.finishedTimersSubject.send(finishedState)

        wait(for: [showCompletedViewCalled], timeout: 0.05)

        XCTAssertEqual(repositoryMock.savedParams?.0, finishedState.startDate)
        XCTAssertEqual(repositoryMock.savedParams?.1, finishedState.endDate)
        XCTAssertEqual(repositoryMock.savedParams?.2, finishedState.comment)
    }
}
