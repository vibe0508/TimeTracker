//
//  ContentView.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 02.03.2022.
//

import SwiftUI

struct ContentView: View {
    private(set) var timerPageView: TimerPageView
    private(set) var timeEntriesView: TimeEntriesListView

    var body: some View {
        TabView {
            timerPageView
                .tabItem {
                    Label("Log time", systemImage: "")
                }

            timeEntriesView
                .tabItem {
                    Label("Time list", systemImage: "")
                }
        }
    }
}
