//
//  TimerPageView.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import SwiftUI

struct TimerPageView: View {
    @State
    var comment: String = ""

    var body: some View {
        VStack {
            Spacer()

            Text("10:00:00")
                .font(.title.monospacedDigit())
                .fontWeight(.semibold)

            TextField(
                "",
                text: $comment,
                prompt: Text("Your comment...")
            )
                .multilineTextAlignment(.center)

            Spacer()

            Button("Start", action: {})

            Spacer()
        }
        .padding()
    }
}

struct TimerPageView_Previews: PreviewProvider {
    static var previews: some View {
        TimerPageView()
.previewInterfaceOrientation(.landscapeLeft)
    }
}
