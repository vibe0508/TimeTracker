//
//  ContentView.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 02.03.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TimerPageView()
                .tabItem {
                    Label("Log time", systemImage: "")
                }

            TimeEntriesListView()
                .tabItem {
                    Label("Time list", systemImage: "")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
