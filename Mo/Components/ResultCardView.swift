import SwiftUI

struct ResultCardView: View {
    let reading: MoReading

    var body: some View {
        InterpretationCardView(entry: reading.entry)
    }
}

struct SummaryCardView: View {
    let entry: MoEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionTitle("SUMMARY")

            Text(entry.summary)
                .font(MoTheme.bodyFont(size: 22))
                .foregroundStyle(MoTheme.primaryText)
                .lineSpacing(8)
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
            .foregroundStyle(MoTheme.secondaryText)
    }
}

struct InterpretationCardView: View {
    let entry: MoEntry

    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            sectionTitle("MEANING")

            Text(entry.interpretation.meaning)
                .font(MoTheme.bodyFont(size: 19))
                .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                .lineSpacing(7)

            sectionTitle("SPIRITUAL PRACTICE")

            Text(entry.interpretation.spiritualPractice)
                .font(MoTheme.bodyFont(size: 19))
                .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                .lineSpacing(7)

            sectionTitle("IN BRIEF")

            Text(entry.interpretation.meaningShort)
                .font(MoTheme.bodyFont(size: 22))
                .foregroundStyle(MoTheme.primaryText)
                .lineSpacing(8)

            sectionTitle("FAVORABLE FOR")

            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(entry.interpretation.favorableFor, id: \.self) { item in
                    Text(item)
                        .font(MoTheme.bodyFont(size: 15).weight(.medium))
                        .foregroundStyle(MoTheme.primaryText)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Capsule(style: .continuous)
                                .fill(MoTheme.background)
                        )
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(MoTheme.accent.opacity(0.25), lineWidth: 1)
                        )
                }
            }

            sectionTitle("CAUTION")

            Text(entry.interpretation.caution)
                .font(MoTheme.bodyFont(size: 19))
                .foregroundStyle(MoTheme.secondaryText)
                .lineSpacing(7)
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 34, style: .continuous)
                .fill(MoTheme.cardBackground)
                .shadow(color: MoTheme.shadow, radius: 18, x: 0, y: 8)
        )
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(MoTheme.bodyFont(size: 14).weight(.semibold))
            .tracking(2.8)
            .foregroundStyle(MoTheme.secondaryText)
    }
}
