//
//  TimeEntriesAssembly.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation

final class TimeEntriesAssembly {
    private let businessLogicAssembly: BusinessLogicAssembly

    init(businessLogicAssembly: BusinessLogicAssembly) {
        self.businessLogicAssembly = businessLogicAssembly
    }

    func makeTimeEntriesListView() -> TimeEntriesListView {
        TimeEntriesListView()
    }
}