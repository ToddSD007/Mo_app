import SwiftUI

struct BringYourOwnDiceView: View {
    @ObservedObject var viewModel: MoAppViewModel
    let onRevealResult: () -> Void

    @State private var primaryFirstDie: Int?
    @State private var primarySecondDie: Int?
    @State private var showsFirmnessCast = false
    @State private var firmnessFirstDie: Int?
    @State private var firmnessSecondDie: Int?
    @State private var showsInstructions = false

    private var isPrimaryComplete: Bool {
        primaryFirstDie != nil && primarySecondDie != nil
    }

    private var firmnessDiceValues: [Int]? {
        guard showsFirmnessCast else { return nil }
        guard let firmnessFirstDie, let firmnessSecondDie else { return nil }
        return [firmnessFirstDie, firmnessSecondDie]
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                header

                ManualCastPairSelector(
                    title: "Main Cast",
                    firstSelection: $primaryFirstDie,
                    secondSelection: $primarySecondDie
                )

                Divider()
                    .overlay(MoTheme.secondaryText.opacity(0.14))

                firmnessSection

                revealButton
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 42)
        }
        .background(MoTheme.background.ignoresSafeArea())
        .sheet(isPresented: $showsInstructions) {
            ManualDiceInstructionsView(resourceName: "bring-your-own-dice-user-instructions")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Bring Your Own Dice")
                .font(MoTheme.headingFont(size: 40))
                .foregroundStyle(MoTheme.primaryText)

            Text("Roll your dice while holding your question in mind, then enter the result below.")
                .font(MoTheme.bodyFont(size: 18))
                .foregroundStyle(MoTheme.secondaryText)
                .lineSpacing(6)

            Button {
                showsInstructions = true
            } label: {
                Text("How to use your own dice")
                    .font(MoTheme.bodyFont(size: 17).weight(.medium))
                    .foregroundStyle(MoTheme.accent)
            }
            .buttonStyle(.plain)
            .padding(.top, 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var firmnessSection: some View {
        if showsFirmnessCast {
            VStack(alignment: .leading, spacing: 18) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Optional Firmness Cast")
                        .font(MoTheme.bodyFont(size: 22).weight(.medium))
                        .foregroundStyle(MoTheme.primaryText)

                    Spacer()

                    Button("Remove") {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showsFirmnessCast = false
                            firmnessFirstDie = nil
                            firmnessSecondDie = nil
                        }
                    }
                    .font(MoTheme.bodyFont(size: 15).weight(.medium))
                    .foregroundStyle(MoTheme.secondaryText)
                }

                ManualCastPairSelector(
                    title: nil,
                    firstSelection: $firmnessFirstDie,
                    secondSelection: $firmnessSecondDie
                )
            }
        } else {
            VStack(alignment: .leading, spacing: 14) {
                Text("Optional Firmness Cast")
                    .font(MoTheme.bodyFont(size: 22).weight(.medium))
                    .foregroundStyle(MoTheme.primaryText)

                Text("Determine how firmly the result should be held.")
                    .font(MoTheme.bodyFont(size: 17))
                    .foregroundStyle(MoTheme.secondaryText)
                    .lineSpacing(5)

                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        showsFirmnessCast = true
                    }
                } label: {
                    Text("Add Firmness Cast")
                        .font(MoTheme.bodyFont(size: 17).weight(.semibold))
                        .foregroundStyle(MoTheme.accent)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 12)
                        .background(
                            Capsule(style: .continuous)
                                .fill(MoTheme.cardBackground)
                                .shadow(color: MoTheme.shadow, radius: 10, x: 0, y: 5)
                        )
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var revealButton: some View {
        Button {
            guard let primaryFirstDie, let primarySecondDie else { return }
            viewModel.revealManualReading(
                primaryDiceValues: [primaryFirstDie, primarySecondDie],
                firmnessDiceValues: firmnessDiceValues
            )
            onRevealResult()
        } label: {
            Text("Reveal the Result")
                .font(MoTheme.bodyFont(size: 19).weight(.semibold))
                .foregroundStyle(.white.opacity(isPrimaryComplete ? 1 : 0.72))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    Capsule(style: .continuous)
                        .fill(isPrimaryComplete ? MoTheme.accent : MoTheme.secondaryText.opacity(0.35))
                )
        }
        .buttonStyle(.plain)
        .disabled(!isPrimaryComplete)
    }
}

private struct ManualCastPairSelector: View {
    let title: String?
    @Binding var firstSelection: Int?
    @Binding var secondSelection: Int?

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            if let title {
                Text(title)
                    .font(MoTheme.bodyFont(size: 22).weight(.medium))
                    .foregroundStyle(MoTheme.primaryText)
            }

            HStack(alignment: .top, spacing: 14) {
                ManualDieSelector(title: "First Die", selection: $firstSelection)
                ManualDieSelector(title: "Second Die", selection: $secondSelection)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct ManualDieSelector: View {
    let title: String
    @Binding var selection: Int?

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text(title)
                .font(MoTheme.bodyFont(size: 16).weight(.semibold))
                .foregroundStyle(MoTheme.secondaryText)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: 10) {
                ForEach(ManualDiceToken.all) { token in
                    Button {
                        selection = token.value
                    } label: {
                        ManualDiceTokenButton(token: token, isSelected: selection == token.value)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private struct ManualDiceTokenButton: View {
    let token: ManualDiceToken
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 8) {
            MoTokenView(
                diceValue: token.value,
                syllable: token.syllable,
                showsLabel: true,
                size: 76
            )

            Text("\(token.value)")
                .font(MoTheme.bodyFont(size: 14).weight(.semibold))
                .tracking(1.4)
                .foregroundStyle(isSelected ? MoTheme.accent : MoTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(isSelected ? MoTheme.accentSoft.opacity(0.42) : Color.clear)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(isSelected ? MoTheme.accent.opacity(0.72) : Color.clear, lineWidth: 1.4)
        )
    }
}

private struct ManualDiceToken: Identifiable {
    let value: Int
    let syllable: String
    let script: String

    var id: Int { value }

    static let all = [
        ManualDiceToken(value: 1, syllable: "DHI", script: "དྷཱི"),
        ManualDiceToken(value: 2, syllable: "RA", script: "ར"),
        ManualDiceToken(value: 3, syllable: "PA", script: "པ"),
        ManualDiceToken(value: 4, syllable: "NA", script: "ན"),
        ManualDiceToken(value: 5, syllable: "TSA", script: "ཙ"),
        ManualDiceToken(value: 6, syllable: "AH", script: "ཨ")
    ]
}

private struct ManualDiceInstructionsView: View {
    let resourceName: String

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(instructionBlocks) { block in
                        instructionBlockView(block)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
            .background(MoTheme.background.ignoresSafeArea())
            .navigationTitle("How to Use Your Own Dice")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(MoTheme.accent)
                }
            }
        }
    }

    private var instructionBlocks: [ManualDiceInstructionBlock] {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "md"),
              let markdown = try? String(contentsOf: url, encoding: .utf8) else {
            return [ManualDiceInstructionBlock(kind: .paragraph(AttributedString("Instructions are unavailable.")))]
        }

        return markdown
            .components(separatedBy: .newlines)
            .compactMap(ManualDiceInstructionBlock.init)
    }

    @ViewBuilder
    private func instructionBlockView(_ block: ManualDiceInstructionBlock) -> some View {
        switch block.kind {
        case .heading(let text):
            Text(text)
                .font(MoTheme.headingFont(size: 34))
                .foregroundStyle(MoTheme.primaryText)
                .padding(.bottom, 4)

        case .subheading(let text):
            Text(text)
                .font(MoTheme.bodyFont(size: 15).weight(.semibold))
                .tracking(2.6)
                .foregroundStyle(MoTheme.accent)
                .padding(.top, 10)

        case .paragraph(let text):
            Text(text)
                .font(MoTheme.bodyFont(size: 18))
                .foregroundStyle(MoTheme.primaryText.opacity(0.96))
                .lineSpacing(7)

        case .bullet(let text):
            HStack(alignment: .top, spacing: 10) {
                Text("•")
                    .font(MoTheme.bodyFont(size: 18))
                    .foregroundStyle(MoTheme.accent)

                Text(text)
                    .font(MoTheme.bodyFont(size: 18))
                    .foregroundStyle(MoTheme.primaryText.opacity(0.96))
                    .lineSpacing(5)
            }
        }
    }
}

private struct ManualDiceInstructionBlock: Identifiable {
    enum Kind {
        case heading(String)
        case subheading(String)
        case paragraph(AttributedString)
        case bullet(AttributedString)
    }

    let id = UUID()
    let kind: Kind

    init(kind: Kind) {
        self.kind = kind
    }

    init?(_ markdownLine: String) {
        let trimmedLine = markdownLine.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedLine.isEmpty else {
            return nil
        }

        if trimmedLine.hasPrefix("# ") {
            self.kind = .heading(String(trimmedLine.dropFirst(2)))
        } else if trimmedLine.hasPrefix("## ") {
            self.kind = .subheading(String(trimmedLine.dropFirst(3)))
        } else if trimmedLine.hasPrefix("- ") {
            self.kind = .bullet(Self.attributed(String(trimmedLine.dropFirst(2))))
        } else {
            self.kind = .paragraph(Self.attributed(trimmedLine))
        }
    }

    private static func attributed(_ markdown: String) -> AttributedString {
        (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
    }
}
