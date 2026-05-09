import SwiftUI

struct SavedReadingsView: View {
    @ObservedObject var viewModel: MoAppViewModel

    var body: some View {
        List {
            Section {
                header
                    .listRowInsets(EdgeInsets(top: 12, leading: 24, bottom: 10, trailing: 24))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)

                if viewModel.savedReadings.isEmpty {
                    emptyState
                        .listRowInsets(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.savedReadings) { reading in
                        NavigationLink {
                            SavedReadingDetailView(savedReading: reading, viewModel: viewModel)
                        } label: {
                            SavedReadingRowView(savedReading: reading)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteSavedReading(reading)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .listRowInsets(EdgeInsets(top: 7, leading: 24, bottom: 7, trailing: 24))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete(perform: viewModel.deleteSavedReadings)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(MoTheme.background.ignoresSafeArea())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Saved Readings")
                .font(MoTheme.headingFont(size: 40))
                .foregroundStyle(MoTheme.primaryText)

            Text("A place for readings you choose to keep and revisit.")
                .font(MoTheme.bodyFont(size: 18))
                .foregroundStyle(MoTheme.secondaryText)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("No saved readings yet")
                .font(MoTheme.bodyFont(size: 21).weight(.medium))
                .foregroundStyle(MoTheme.primaryText)

            Text("After a cast, tap Save Reading on the result screen to keep it here.")
                .font(MoTheme.bodyFont(size: 17))
                .foregroundStyle(MoTheme.secondaryText)
                .lineSpacing(5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(MoTheme.cardBackground)
                .shadow(color: MoTheme.shadow, radius: 14, x: 0, y: 7)
        )
        .padding(.top, 10)
    }
}

struct SavedReadingRowView: View {
    let savedReading: SavedReading

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 7) {
                Text(savedReading.title)
                    .font(MoTheme.bodyFont(size: 20).weight(.medium))
                    .foregroundStyle(MoTheme.primaryText)
                    .multilineTextAlignment(.leading)

                Text(savedReading.displaySyllables)
                    .font(MoTheme.bodyFont(size: 15).weight(.medium))
                    .tracking(1.8)
                    .foregroundStyle(MoTheme.accent)

                Text(savedReading.savedAt.formatted(date: .abbreviated, time: .shortened))
                    .font(MoTheme.bodyFont(size: 14))
                    .foregroundStyle(MoTheme.secondaryText)

                if let question = savedReading.question {
                    Text(question)
                        .font(MoTheme.bodyFont(size: 15))
                        .foregroundStyle(MoTheme.secondaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 2)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(MoTheme.cardBackground)
                .shadow(color: MoTheme.shadow, radius: 12, x: 0, y: 6)
        )
    }
}

struct SavedReadingDetailView: View {
    let savedReading: SavedReading
    @ObservedObject var viewModel: MoAppViewModel

    private var currentSavedReading: SavedReading {
        viewModel.savedReadings.first { $0.id == savedReading.id } ?? savedReading
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                VStack(spacing: 18) {
                    Text("SAVED READING")
                        .font(MoTheme.bodyFont(size: 18).weight(.medium))
                        .tracking(4.8)
                        .foregroundStyle(MoTheme.secondaryText.opacity(0.55))

                    HStack(spacing: 24) {
                        ForEach(Array(savedReading.primaryCast.syllables.enumerated()), id: \.offset) { item in
                            MoTokenView(
                                diceValue: savedReading.primaryCast.diceValues[item.offset],
                                syllable: item.element,
                                showsLabel: true,
                                size: 96
                            )
                        }
                    }
                    .padding(.top, 8)

                    VStack(spacing: 10) {
                        Text(savedReading.entry.title)
                            .font(MoTheme.headingFont(size: 42))
                            .foregroundStyle(MoTheme.primaryText.opacity(0.84))
                            .multilineTextAlignment(.center)

                        Text(savedReading.entry.overallTone.uppercased())
                            .font(MoTheme.bodyFont(size: 16).weight(.medium))
                            .tracking(4)
                            .foregroundStyle(MoTheme.accent)
                    }
                    .padding(.top, 8)

                    bookmarkButton
                }

                savedMetadataSection
                if let firmness = savedReading.firmness {
                    firmnessSection(firmness)
                }
                SummaryCardView(entry: savedReading.entry)
                InterpretationCardView(entry: savedReading.entry)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 42)
        }
        .background(MoTheme.background.ignoresSafeArea())
        .alert(
            "Unable to Update Bookmark",
            isPresented: Binding(
                get: { viewModel.savedReadingErrorMessage != nil },
                set: { if !$0 { viewModel.savedReadingErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { viewModel.savedReadingErrorMessage = nil }
        } message: {
            Text(viewModel.savedReadingErrorMessage ?? "")
        }
    }

    private var bookmarkButton: some View {
        Button {
            viewModel.toggleSavedReadingBookmark(currentSavedReading)
        } label: {
            Label(
                currentSavedReading.isBookmarked ? "Bookmarked" : "Bookmark Reading",
                systemImage: currentSavedReading.isBookmarked ? "bookmark.fill" : "bookmark"
            )
            .font(MoTheme.bodyFont(size: 17).weight(.semibold))
            .foregroundStyle(currentSavedReading.isBookmarked ? MoTheme.accent : MoTheme.primaryText)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                Capsule()
                    .fill(MoTheme.cardBackground)
                    .shadow(color: MoTheme.shadow, radius: 10, x: 0, y: 5)
            )
        }
        .buttonStyle(.plain)
    }

    private var savedMetadataSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("SAVED")

            Text(currentSavedReading.savedAt.formatted(date: .complete, time: .shortened))
                .font(MoTheme.bodyFont(size: 18))
                .foregroundStyle(MoTheme.primaryText.opacity(0.95))

            if let question = currentSavedReading.question {
                Text(question)
                    .font(MoTheme.bodyFont(size: 19))
                    .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                    .lineSpacing(6)
                    .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(cardBackground)
    }

    private func firmnessSection(_ firmness: MoFirmness) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("FIRMNESS")

            Text(firmness.title)
                .font(MoTheme.bodyFont(size: 20).weight(.medium))
                .foregroundStyle(MoTheme.primaryText.opacity(0.95))

            Text(firmness.description)
                .font(MoTheme.bodyFont(size: 17))
                .foregroundStyle(MoTheme.secondaryText)
                .lineSpacing(5)

            if let secondaryCast = savedReading.secondaryCast {
                Text("Second cast: \(secondaryCast.displaySyllables)")
                    .font(MoTheme.bodyFont(size: 15).weight(.medium))
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.85))
            }

            if savedReading.firmnessSource == .manual {
                Text("Firmness determined from manual cast")
                    .font(MoTheme.bodyFont(size: 13))
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.7))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(24)
        .background(cardBackground)
    }

    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(MoTheme.cardBackground)
            .shadow(color: MoTheme.shadow, radius: 16, x: 0, y: 7)
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(MoTheme.bodyFont(size: 14).weight(.semibold))
            .tracking(2.8)
            .foregroundStyle(MoTheme.accent)
    }
}
