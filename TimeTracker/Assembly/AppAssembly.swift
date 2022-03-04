//
//  AppAssembly.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation

final class AppAssembly {
    private(set) lazy var contentView = ContentView(
        timerPageView: timerPageAssembly.makeTimerPageView(),
        timeEntriesView: timeEntriesAssembly.makeTimeEntriesListView()
    )
    
    private let coreDataAssembly = CoreDataAssembly()
    private lazy var businessLogicAssembly = BusinessLogicAssembly(coreDataAssembly: coreDataAssembly)
    private lazy var timerPageAssembly = TimerPageAssembly(businessLogicAssembly: businessLogicAssembly)
    private lazy var timeEntriesAssembly = TimeEntriesAssembly(businessLogicAssembly: businessLogicAssembly)
}
