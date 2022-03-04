//
//  TimerPageView.swift
//  TimeTracker
//
//  Created by Вячеслав Бельтюков on 03.03.2022.
//

import SwiftUI

struct TimerPageView: View {
    @ObservedObject
    var viewModel: TimerPageViewModel

    @State
    var comment: String = ""

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                Text(viewModel.timerText)
                    .font(.title.monospacedDigit())
                    .fontWeight(.semibold)

                TextField(
                    "",
                    text: viewModel.commentBinding,
                    prompt: Text("Your comment...")
                )
                    .multilineTextAlignment(.center)

                Spacer()

                Button(viewModel.buttonTitle, action: viewModel.onButtonTap)

                Spacer()
            }

            Color(uiColor: .systemBackground)
                .opacity(viewModel.showCompletedView ? 1 : 0)
                .animation(.easeInOut)

            Text("Time saved")
                .font(.title)
                .opacity(viewModel.showCompletedView ? 1 : 0)
                .animation(.easeInOut, value: viewModel.showCompletedView)

        }
        .padding()
    }
}
