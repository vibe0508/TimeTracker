//
//  TimeEntryListViewModel.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 04.03.2022.
//

import Foundation
import Combine

final class TimeEntryListViewModel: ObservableObject {
    @Published
    private(set) var entries: [TimeEntriesListView.Entry] = []

    private let repository: TimeEntryRepository
    private let timeFormatter: TimeFormatter
    private let dateFormatter: DateFormatter

    init(repository: TimeEntryRepository, timeFormatter: TimeFormatter, dateFormatter: DateFormatter) {
        self.repository = repository
        self.timeFormatter = timeFormatter
        self.dateFormatter = dateFormatter

        setupBindings()
    }

    private func setupBindings() {
        repository.entriesPublisher
            .map { [timeFormatter, dateFormatter] in
                $0.map {
                    TimeEntriesListView.Entry(
                        id: $0.id,
                        date: dateFormatter.string(from: $0.startDate),
                        duration: timeFormatter.timeString(startDate: $0.startDate, endDate: $0.endDate),
                        comment: $0.comment
                    )
                }
            }
            .assign(to: &$entries)
    }
}
