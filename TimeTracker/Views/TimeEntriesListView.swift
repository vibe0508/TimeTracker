//
//  TimeEntriesListView.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import SwiftUI

struct TimeEntriesListView: View {
    @State
    var entries: [Entry] = [
        .init(id: .init(), date: "18 Aug 21", duration: "00:56:78", comment: nil),
        .init(id: .init(), date: "28 Sep 28", duration: "00:87:78", comment: "A very very very long commment")
    ]
    var body: some View {
        List(entries) {
            TimeEntryView(
                date: $0.date,
                duration: $0.duration,
                comment: $0.comment
            )
        }
        .listStyle(.plain)
    }
}

extension TimeEntriesListView {
    struct Entry: Identifiable {
        typealias ID = UUID

        let id: UUID
        let date: String
        let duration: String
        let comment: String?
    }
}

struct TimeEntriesListView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEntriesListView()
    }
}
