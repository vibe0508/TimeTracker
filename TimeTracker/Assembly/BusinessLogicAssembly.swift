//
//  BusinessLogicAssembly.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation

final class BusinessLogicAssembly {
    private(set) lazy var timeEntryRepository: TimeEntryRepository = TimeEntryRepositoryImpl(
        managedObjectContext: coreDataAssembly.makeManagedObjectContext()
    )

    private let coreDataAssembly: CoreDataAssembly

    init(coreDataAssembly: CoreDataAssembly) {
        self.coreDataAssembly = coreDataAssembly
    }

    func makeTimeFormatter() -> TimeFormatter {
        TimeFormatterImpl()
    }

    func makeTimerStateManager() -> TimerStateManager {
        TimerStateManagerImpl()
    }
}
