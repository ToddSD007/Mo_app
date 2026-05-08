import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: MoAppViewModel
    let onOpenMenu: () -> Void
    @State private var readingQuestion = ""

    var body: some View {
        ZStack {
            MoTheme.background
                .ignoresSafeArea()

            if let reading = viewModel.currentReading {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        header

                        VStack(spacing: 18) {
                            Text("DIVINATION RESULT")
                                .font(MoTheme.bodyFont(size: 18).weight(.medium))
                                .tracking(4.8)
                                .foregroundStyle(MoTheme.secondaryText.opacity(0.55))

                            HStack(spacing: 24) {
                                ForEach(Array(reading.syllables.enumerated()), id: \.offset) { item in
                                    MoTokenView(
                                        diceValue: reading.diceValues[item.offset],
                                        syllable: item.element,
                                        showsLabel: true,
                                        size: 96
                                    )
                                }
                            }
                            .padding(.top, 8)

                            VStack(spacing: 10) {
                                Text(reading.entry.title)
                                    .font(MoTheme.headingFont(size: 42))
                                    .foregroundStyle(MoTheme.primaryText.opacity(0.84))
                                    .multilineTextAlignment(.center)

                                Text(reading.entry.overallTone.uppercased())
                                    .font(MoTheme.bodyFont(size: 16).weight(.medium))
                                    .tracking(4)
                                    .foregroundStyle(MoTheme.accent)
                            }
                            .padding(.top, 8)
                        }

                        firmnessSection(reading)

                        saveSection

                        SummaryCardView(entry: reading.entry)

                        ResultCardView(reading: reading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 18)
                    .padding(.bottom, 42)
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 4)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .alert(
            "Unable to Save Reading",
            isPresented: Binding(
                get: { viewModel.savedReadingErrorMessage != nil },
                set: { if !$0 { viewModel.savedReadingErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.savedReadingErrorMessage ?? "")
        }
    }

    private var header: some View {
        HStack {
            Button(action: viewModel.returnHome) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(MoTheme.secondaryText)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.7))
                    )
                    .overlay(
                        Circle()
                            .stroke(MoTheme.accent.opacity(0.1), lineWidth: 1)
                    )
            }

            Spacer()

            Button(action: onOpenMenu) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(MoTheme.secondaryText)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.7))
                    )
                    .overlay(
                        Circle()
                            .stroke(MoTheme.accent.opacity(0.1), lineWidth: 1)
                    )
            }
        }
        .padding(.top, 8)
    }

    private func firmnessSection(_ reading: MoReading) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("FIRMNESS")
                .font(MoTheme.bodyFont(size: 14).weight(.semibold))
                .tracking(2.8)
                .foregroundStyle(MoTheme.accent)

            Text(reading.firmness.title)
                .font(MoTheme.bodyFont(size: 20).weight(.medium))
                .foregroundStyle(MoTheme.primaryText.opacity(0.95))

            Text(reading.firmness.description)
                .font(MoTheme.bodyFont(size: 17))
                .foregroundStyle(MoTheme.secondaryText)
                .lineSpacing(5)

            Text("Second cast: \(reading.secondaryCast.displaySyllables)")
                .font(MoTheme.bodyFont(size: 15).weight(.medium))
                .foregroundStyle(MoTheme.secondaryText.opacity(0.85))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(MoTheme.cardBackground)
            .shadow(color: MoTheme.shadow, radius: 16, x: 0, y: 7)
        )
    }

    private var saveSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 14) {
                Image(systemName: viewModel.isCurrentReadingSaved ? "checkmark.circle.fill" : "bookmark")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(MoTheme.accent)

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.isCurrentReadingSaved ? "Reading Saved" : "Save Reading")
                        .font(MoTheme.bodyFont(size: 19).weight(.medium))
                        .foregroundStyle(MoTheme.primaryText)

                    Text(viewModel.isCurrentReadingSaved ? "This reading is in your saved readings." : "Keep this reading for later reflection.")
                        .font(MoTheme.bodyFont(size: 15))
                        .foregroundStyle(MoTheme.secondaryText)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 0)
            }

            if !viewModel.isCurrentReadingSaved {
                TextField("Question or note (optional)", text: $readingQuestion)
                    .font(MoTheme.bodyFont(size: 17))
                    .textInputAutocapitalization(.sentences)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(MoTheme.background)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(MoTheme.accent.opacity(0.18), lineWidth: 1)
                    )

                Button {
                    viewModel.saveCurrentReading(question: readingQuestion)
                } label: {
                    Text("Save")
                        .font(MoTheme.bodyFont(size: 17).weight(.semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(MoTheme.accent, in: Capsule())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(MoTheme.cardBackground)
                .shadow(color: MoTheme.shadow, radius: 14, x: 0, y: 7)
        )
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultPreviewContainer()
    }
}

private struct ResultPreviewContainer: View {
    let viewModel: MoAppViewModel = {
        let viewModel = MoAppViewModel.makePreview()
        viewModel.loadPreviewReading()
        return viewModel
    }()

    var body: some View {
        ResultView(viewModel: viewModel, onOpenMenu: {})
    }
}
