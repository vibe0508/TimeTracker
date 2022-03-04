//
//  TimerPageAssembly.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation

final class TimerPageAssembly {
    private let businessLogicAssembly: BusinessLogicAssembly

    init(businessLogicAssembly: BusinessLogicAssembly) {
        self.businessLogicAssembly = businessLogicAssembly
    }

    func makeTimerPageView() -> TimerPageView {
        TimerPageView(viewModel: makeViewModel())
    }

    private func makeViewModel() -> TimerPageViewModel {
        TimerPageViewModel(
            timeFormatter: businessLogicAssembly.makeTimeFormatter(),
            timerStateManager: businessLogicAssembly.makeTimerStateManager(),
            timeEntryRepository: businessLogicAssembly.timeEntryRepository
        )
    }
}
