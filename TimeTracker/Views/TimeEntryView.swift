//
//  TimeEntryView.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import SwiftUI

struct TimeEntryView: View {
    @State
    var date: String = "18 Aug 20"

    @State
    var duration: String = "00:56:67"

    @State
    var comment: String? = "F comment jvhmbjk jbhjb jhb"

    var body: some View {
        HStack() {
            Text(date)
                .foregroundColor(Color.gray)

            Text(duration)

            if let comment = comment {
                Text(comment)
                    .foregroundColor(Color.gray)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer()
        }
        .padding()
        .font(.footnote)
    }
}

struct TimeEntryView_Previews: PreviewProvider {
    static var previews: some View {
        TimeEntryView()
    }
}
