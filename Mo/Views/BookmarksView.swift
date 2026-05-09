import SwiftUI

struct BookmarksView: View {
    @ObservedObject var viewModel: MoAppViewModel

    var body: some View {
        List {
            Section {
                header
                    .listRowInsets(EdgeInsets(top: 12, leading: 24, bottom: 10, trailing: 24))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }

            Section {
                if viewModel.bookmarkedSavedReadings.isEmpty {
                    emptyState(
                        title: "No bookmarked readings yet",
                        message: "Open a saved reading and tap Bookmark Reading to keep it close."
                    )
                    .listRowInsets(EdgeInsets(top: 0, leading: 24, bottom: 14, trailing: 24))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.bookmarkedSavedReadings) { reading in
                        NavigationLink {
                            SavedReadingDetailView(savedReading: reading, viewModel: viewModel)
                        } label: {
                            SavedReadingRowView(savedReading: reading)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                viewModel.toggleSavedReadingBookmark(reading)
                            } label: {
                                Label("Remove Bookmark", systemImage: "bookmark.slash")
                            }
                            .tint(MoTheme.accent)
                        }
                        .listRowInsets(EdgeInsets(top: 7, leading: 24, bottom: 7, trailing: 24))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            } header: {
                sectionHeader("Readings")
            }

            Section {
                if viewModel.bookmarkedEntries.isEmpty {
                    emptyState(
                        title: "No bookmarked entries yet",
                        message: "Open an entry from The 36 Divinations and tap Bookmark Entry to add it here."
                    )
                    .listRowInsets(EdgeInsets(top: 0, leading: 24, bottom: 14, trailing: 24))
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(viewModel.bookmarkedEntries) { entry in
                        NavigationLink {
                            EntryDetailView(entry: entry, viewModel: viewModel)
                        } label: {
                            EntryRowView(entry: entry, showsChevron: false)
                        }
                        .buttonStyle(.plain)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button {
                                viewModel.toggleEntryBookmark(entry)
                            } label: {
                                Label("Remove Bookmark", systemImage: "bookmark.slash")
                            }
                            .tint(MoTheme.accent)
                        }
                        .listRowInsets(EdgeInsets(top: 7, leading: 24, bottom: 7, trailing: 24))
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
            } header: {
                sectionHeader("Entries")
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(MoTheme.background.ignoresSafeArea())
        .alert(
            "Unable to Update Bookmark",
            isPresented: Binding(
                get: { viewModel.bookmarkErrorMessage != nil || viewModel.savedReadingErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.bookmarkErrorMessage = nil
                        viewModel.savedReadingErrorMessage = nil
                    }
                }
            )
        ) {
            Button("OK", role: .cancel) {
                viewModel.bookmarkErrorMessage = nil
                viewModel.savedReadingErrorMessage = nil
            }
        } message: {
            Text(viewModel.bookmarkErrorMessage ?? viewModel.savedReadingErrorMessage ?? "")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("Bookmarks")
                .font(MoTheme.headingFont(size: 40))
                .foregroundStyle(MoTheme.primaryText)

            Text("Return to readings and entries you have marked for study.")
                .font(MoTheme.bodyFont(size: 18))
                .foregroundStyle(MoTheme.secondaryText)
                .lineSpacing(6)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sectionHeader(_ title: String) -> some View {
        Text(title.uppercased())
            .font(MoTheme.bodyFont(size: 13).weight(.semibold))
            .tracking(2.8)
            .foregroundStyle(MoTheme.accent)
            .padding(.leading, 8)
    }

    private func emptyState(title: String, message: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(MoTheme.bodyFont(size: 21).weight(.medium))
                .foregroundStyle(MoTheme.primaryText)

            Text(message)
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
        .padding(.top, 4)
    }
}
