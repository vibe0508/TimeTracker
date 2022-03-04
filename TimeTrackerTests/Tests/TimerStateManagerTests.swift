//
//  TimerStateManagerTests.swift
//  TimeTrackerTests
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import Foundation
import XCTest
import Combine
@testable import TimeTracker

class TimerStateManagerTests: XCTestCase {
    var timerManager: TimerStateManagerImpl!

    @Published
    var timerStatus: TimerStatus?

    @Published
    var comment: String?

    @Published
    var finishedState: TimerFinishedState?

    var cancellables: [Cancellable] = []

    override func setUpWithError() throws {
        try super.setUpWithError()

        timerManager = TimerStateManagerImpl()

        cancellables.append(
            timerManager.timerStatus
                .dropFirst()
                .sink(receiveValue: { [weak self] in
                    self?.timerStatus = $0
                })
        )

        cancellables.append(
            timerManager.comment
                .dropFirst()
                .sink(receiveValue: { [weak self] in
                    self?.comment = $0
                })
        )

        cancellables.append(
            timerManager.finishedTimers
                .sink(receiveValue: { [weak self] in
                    self?.finishedState = $0
                })
        )
    }

    override func tearDown() {
        super.tearDown()

        cancellables.forEach {
            $0.cancel()
        }
        cancellables = []
    }

    func testStartTimer() {
        timerManager.startTimer()

        XCTAssertNil(comment)
        XCTAssertNil(finishedState)

        guard let timerStatus = timerStatus, case let .inProgress(startDate) = timerStatus else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(startDate.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 0.01)
    }

    func testStopTimer() {
        let start = Date()
        timerManager.startTimer()

        sleep(1)

        timerManager.stopTimer()

        XCTAssertNil(comment)
        XCTAssertNil(finishedState)

        guard let timerStatus = timerStatus, case let .finished(startDate, endDate) = timerStatus else {
            XCTAssert(false)
            return
        }

        XCTAssertEqual(startDate.timeIntervalSince1970, start.timeIntervalSince1970, accuracy: 0.01)
        XCTAssertEqual(endDate.timeIntervalSince1970, Date().timeIntervalSince1970, accuracy: 0.01)
    }

    func testChangeCommentBeforeStart() {
        let comment = UUID().uuidString
        timerManager.updateComment(comment)

        timerManager.startTimer()

        XCTAssertEqual(self.comment, comment)
    }

    func testChangeCommentInProgress() {
        let comment = UUID().uuidString

        timerManager.startTimer()
        timerManager.updateComment(comment)
        timerManager.stopTimer()

        XCTAssertEqual(self.comment, comment)
    }

    func testCompletion() {
        let comment = UUID().uuidString
        let startDate = Date()

        timerManager.startTimer()
        timerManager.updateComment(comment)

        sleep(1)
        let endDate = Date()
        timerManager.stopTimer()

        let completionCalled = expectation(description: "Completion called")

        cancellables.append(
            $finishedState
                .compactMap { $0 }
                .sink(receiveValue: {
                    XCTAssertEqual($0.startDate.timeIntervalSince1970, startDate.timeIntervalSince1970, accuracy: 0.01)
                    XCTAssertEqual($0.endDate.timeIntervalSince1970, endDate.timeIntervalSince1970, accuracy: 0.01)
                    XCTAssertEqual($0.comment, comment)
                    completionCalled.fulfill()
                })
        )

        wait(for: [completionCalled], timeout: 5.5)

        XCTAssertEqual(timerStatus, .notStarted)
    }

    func testCommentEditAfterFinish() {
        let commentOne = UUID().uuidString
        let commentTwo = UUID().uuidString

        timerManager.startTimer()
        timerManager.updateComment(commentOne)

        sleep(1)
        timerManager.stopTimer()

        sleep(1)
        timerManager.updateComment(commentTwo)

        let completionCalled = expectation(description: "Completion called")
        let completionNotCalled = expectation(description: "Completion called")
        completionNotCalled.isInverted = true

        cancellables.append(
            $finishedState
                .compactMap { $0 }
                .sink(receiveValue: {
                    XCTAssertEqual($0.comment, commentTwo)
                    completionNotCalled.fulfill()
                    completionCalled.fulfill()
                })
        )

        wait(for: [completionNotCalled], timeout: 5.5)
        wait(for: [completionCalled], timeout: 2)
    }
}
