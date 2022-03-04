//
//  TimeEntriesListView.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import SwiftUI

struct TimeEntriesListView: View {
    @ObservedObject
    var viewModel: TimeEntryListViewModel

    var body: some View {
        List {
            ForEach(viewModel.entries) {
                TimeEntryView(
                    date: $0.date,
                    duration: $0.duration,
                    comment: $0.comment
                )
            }
            .onDelete { [viewModel] indexSet in
                viewModel.delete(at: indexSet)
            }
        }
        .listStyle(.plain)
    }
}

extension TimeEntriesListView {
    struct Entry: Identifiable, Equatable {
        typealias ID = UUID

        let id: UUID
        let date: String
        let duration: String
        let comment: String?
    }
}
