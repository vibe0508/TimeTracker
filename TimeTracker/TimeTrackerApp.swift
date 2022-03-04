//
//  TimeTrackerApp.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 02.03.2022.
//

import SwiftUI

@main
struct TimeTrackerApp: App {
    let appAssembly = AppAssembly()

    var body: some Scene {
        WindowGroup {
            appAssembly.contentView
        }
    }
}
