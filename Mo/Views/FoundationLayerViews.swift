import SwiftUI

enum AppMenuDestination: Hashable {
    case introduction
    case howToConsult
    case entries
    case readings
    case bringYourOwnDice
    case manualResult
}

struct HomeMenuSheet: View {
    let onSelect: (AppMenuDestination) -> Void
    @State private var measuredHeight: CGFloat = 320

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 22) {
                menuButton(title: "Introduction", subtitle: "What Mo is and how to approach it.") {
                    onSelect(.introduction)
                }

                menuButton(title: "How to Consult", subtitle: "Practical guidance for asking and receiving well.") {
                    onSelect(.howToConsult)
                }

                menuButton(title: "The 36 Divinations", subtitle: "Browse the full cycle of Mo results as a study reference.") {
                    onSelect(.entries)
                }

                menuButton(title: "Saved Readings", subtitle: "Return to readings you have chosen to keep.") {
                    onSelect(.readings)
                }

                menuButton(title: "Bring Your Own Dice", subtitle: "Use physical dice to reveal the result.") {
                    onSelect(.bringYourOwnDice)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(28)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: MenuSheetHeightPreferenceKey.self, value: geometry.size.height)
                }
            )
            .onPreferenceChange(MenuSheetHeightPreferenceKey.self) { height in
                measuredHeight = max(height, 260)
            }
            .presentationDetents([.height(measuredHeight)])
            .presentationDragIndicator(.visible)
            .background(MoTheme.background)
        }
    }

    private func menuButton(title: String, subtitle: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(MoTheme.bodyFont(size: 20).weight(.medium))
                    .foregroundStyle(MoTheme.primaryText)

                Text(subtitle)
                    .font(MoTheme.bodyFont(size: 15))
                    .foregroundStyle(MoTheme.secondaryText)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(MoTheme.cardBackground)
                    .shadow(color: MoTheme.shadow, radius: 12, x: 0, y: 6)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct MenuSheetHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 320

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct OnboardingView: View {
    let onBegin: (Bool) -> Void

    @State private var selection = 0
    @State private var shouldSkipFutureLaunches = false

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "A moment of stillness",
            paragraphs: [
                "Before you cast, pause for a moment.",
                "This is not about chance. In Mo, the cast is a way of revealing conditions through mind, intention, and interdependence.",
                "You do not need to be perfect. Just sincere."
            ]
        ),
        OnboardingPage(
            title: "Hold one clear question",
            paragraphs: [
                "The Mo works best when the question is:"
            ],
            bullets: [
                "clear",
                "specific",
                "one at a time"
            ],
            examplesTitle: "Good examples:",
            examples: [
                "Is it favorable to move forward with this plan?",
                "What are the conditions around this relationship?",
                "How should I understand this obstacle?"
            ],
            closing: "The clearer the question, the clearer the answer."
        ),
        OnboardingPage(
            title: "Consulting wisdom",
            paragraphs: [
                "Before the cast, bring your question gently to mind.",
                "The mantra of Manjushri helps gather and steady the mind. In this tradition, it is not decoration — it is part of the ritual.",
                "When you are ready, cast with sincerity and receive the answer with openness.",
                "You can learn more anytime in:"
            ],
            bullets: [
                "Introduction",
                "How to Consult the Mo"
            ]
        )
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    MoTheme.background,
                    Color.white.opacity(0.96)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                TabView(selection: $selection) {
                    ForEach(Array(pages.enumerated()), id: \.offset) { index, page in
                        OnboardingPageView(page: page)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                VStack(spacing: 14) {
                    Button {
                        shouldSkipFutureLaunches.toggle()
                    } label: {
                        HStack(spacing: 10) {
                            Image(systemName: shouldSkipFutureLaunches ? "checkmark.square.fill" : "square")
                                .font(.system(size: 20, weight: .medium))

                            Text("Don't show this again")
                                .font(MoTheme.bodyFont(size: 16).weight(.medium))
                        }
                        .foregroundStyle(MoTheme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.plain)

                    HStack(spacing: 12) {
                        if selection > 0 {
                            Button("Back") {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selection -= 1
                                }
                            }
                            .font(MoTheme.bodyFont(size: 17).weight(.medium))
                            .foregroundStyle(MoTheme.secondaryText)
                        }

                        Spacer()

                        Button(selection == pages.count - 1 ? "Begin" : "Next") {
                            if selection == pages.count - 1 {
                                onBegin(shouldSkipFutureLaunches)
                            } else {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    selection += 1
                                }
                            }
                        }
                        .font(MoTheme.bodyFont(size: 19).weight(.semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 26)
                        .padding(.vertical, 14)
                        .background(MoTheme.accent, in: Capsule())
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .fill(MoTheme.cardBackground.opacity(0.96))
                        .shadow(color: MoTheme.shadow, radius: 14, x: 0, y: 7)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(MoTheme.accent.opacity(0.16), lineWidth: 1)
                )
                .padding(.horizontal, 22)
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
        }
        .interactiveDismissDisabled()
    }
}

private struct OnboardingPage {
    let title: String
    let paragraphs: [String]
    var bullets: [String] = []
    var examplesTitle: String?
    var examples: [String] = []
    var closing: String?
}

private struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                Image(systemName: "circle.hexagongrid.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(MoTheme.accent.opacity(0.9))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 4)

                Text(page.title)
                    .font(MoTheme.headingFont(size: 36))
                    .foregroundStyle(MoTheme.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 14) {
                    ForEach(page.paragraphs, id: \.self) { paragraph in
                        Text(paragraph)
                            .font(MoTheme.bodyFont(size: 20))
                            .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                            .lineSpacing(7)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if !page.bullets.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(page.bullets, id: \.self) { item in
                                Text("• \(item)")
                                    .font(MoTheme.bodyFont(size: 19))
                                    .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.leading, 2)
                    }

                    if let examplesTitle = page.examplesTitle {
                        Text(examplesTitle)
                            .font(MoTheme.bodyFont(size: 19).weight(.medium))
                            .foregroundStyle(MoTheme.secondaryText)
                            .padding(.top, 4)
                    }

                    if !page.examples.isEmpty {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(page.examples, id: \.self) { item in
                                Text("• \(item)")
                                    .font(MoTheme.bodyFont(size: 19))
                                    .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.leading, 2)
                    }

                    if let closing = page.closing {
                        Text(closing)
                            .font(MoTheme.bodyFont(size: 20))
                            .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                            .lineSpacing(7)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                    }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 28)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
    }
}

struct IntroductionView: View {
    var body: some View {
        EditorialArticleView(
            title: "Introduction",
            sections: [
                EditorialSection(
                    title: "What is Mo?",
                    body: [
                        "Mo is a traditional Tibetan system of divination used to seek clarity when the path ahead is uncertain. For centuries, practitioners have turned to Mo when facing questions about decisions, relationships, health, travel, obstacles, spiritual practice, and the right timing for action.",
                        "Although Mo is often performed with dice or tokens, it is not based on the idea that life is being handed over to chance. In the Tibetan Buddhist understanding, this is not mere randomness. Mo works through interdependence: the meeting of mind, intention, conditions, prayer, and symbolic form.",
                        "In this practice, the outer cast is only one part of the process. The deeper basis is the state of mind with which the question is asked. When the mind is gathered, sincere, and clear, the result is not simply \"what came up,\" but a reflection arising within a meaningful web of causes and conditions. The cast becomes a way of revealing what is already moving beneath the surface.",
                        "This is why intention matters so much. Before consulting the Mo, one does not merely \"ask a question.\" One settles the mind, holds the situation sincerely, and turns toward wisdom."
                    ]
                ),
                EditorialSection(
                    title: "Why Manjushri?",
                    body: [
                        "This form of Mo is associated with Manjushri, the bodhisattva of wisdom. In Tibetan Buddhism, Manjushri represents clear seeing, penetrating insight, and the ability to cut through confusion.",
                        "The mantra used in this practice is a way of orienting the mind toward that wisdom. It is not decoration, and it is not superstition. It is part of the ritual container that helps gather attention, refine intention, and align the mind with clarity rather than fear, haste, or grasping.",
                        "In this sense, Mo is not about trying to force an answer out of the universe. It is about consulting wisdom."
                    ]
                ),
                EditorialSection(
                    title: "A Living Tradition",
                    body: [
                        "Mo is not a novelty system, a personality quiz, or a spiritual gimmick. It belongs to a long and respected Tibetan tradition of divinatory practice that has been relied upon for generations. It has been used not only by lay practitioners, but also by monks, teachers, and accomplished spiritual masters when clarity was needed in uncertain circumstances.",
                        "That lineage matters.",
                        "Tradition does not guarantee that every question will be answered in the way we hope. But it does mean that this method has been tested, preserved, and trusted within a serious contemplative culture. Mo has endured because it is not approached as entertainment. It is approached as a ritual means of discerning conditions wisely.",
                        "This app offers a respectful, simplified way to engage that tradition."
                    ]
                ),
                EditorialSection(
                    title: "How to Approach This Practice",
                    body: [
                        "The purpose of Mo is not to surrender your life to an external force. It is to receive guidance with sincerity and discernment.",
                        "Approach the practice with:",
                        "The answer is not meant to replace your judgment. It is meant to illuminate it.",
                        "Mo is strongest when approached with reverence, honesty, and openness. The more settled the mind, the more interpretable the answer tends to be.",
                        "You are not rolling into fate.",
                        "You are entering into a conversation with wisdom."
                    ],
                    bullets: [
                        "a calm mind",
                        "a clear intention",
                        "one question at a time",
                        "a willingness to hear what is shown"
                    ]
                )
            ]
        )
    }
}

struct HowToConsultView: View {
    var body: some View {
        EditorialArticleView(
            title: "How to Consult the Mo",
            sections: [
                EditorialSection(
                    title: "Begin by Settling the Mind",
                    body: [
                        "Before consulting the Mo, pause.",
                        "Let the mind become a little quieter. Let the urgency of the question soften just enough that you can hold it clearly. You do not need a perfectly blank mind, but you do need a sincere one.",
                        "This sequence matters. It reminds us that the point is not to demand an answer, but to prepare the mind to receive one."
                    ]
                ),
                EditorialSection(
                    title: "The Role of the Mantra",
                    body: [
                        "A mantra is often described as \"that which protects the mind.\" In this practice, the mantra is not an ornament and not merely a sacred phrase to set the mood. It is part of the method itself.",
                        "The mantra of Manjushri is:",
                        "OM AH RA PA TSA NA DHI",
                        "For practice, it is enough to understand this: the mantra is nothing less than Manjushri himself in the form of sound. To recite it is to orient the mind toward wisdom, clarity, and the cutting through of confusion. It protects the mind by gathering it, steadying it, and turning it away from fear, agitation, and scattered thought.",
                        "When you recite or contemplate the mantra before a cast, you are not trying to \"make the app work.\" You are entering the ritual properly."
                    ]
                ),
                EditorialSection(
                    title: "Set the Intention Before the Cast",
                    body: [
                        "The cast should come after the question has already become clear in your mind.",
                        "Do not cast first and search for a question afterward. Do not hold several different questions at once. Do not ask in a mood of panic, resentment, or restless repetition. The more confused the question, the harder it will be to understand the answer.",
                        "A good approach is:"
                    ],
                    bullets: [
                        "settle the mind",
                        "bring one situation to mind",
                        "feel what is genuinely being asked",
                        "phrase it inwardly in a simple, direct way",
                        "then cast"
                    ]
                ),
                EditorialSection(
                    title: "What Makes a Question Good?",
                    body: [
                        "A good question is:",
                        "A weak question is vague, sprawling, emotionally loaded, or impossible to interpret in action.",
                        "The Mo is especially well suited to questions like:"
                    ],
                    bullets: [
                        "clear",
                        "singular",
                        "situated in real life",
                        "open to guidance",
                        "phrased so the answer can actually be used"
                    ],
                    followUpBullets: [
                        "the direction of a relationship",
                        "whether a plan is favorable",
                        "how a difficulty is likely to unfold",
                        "whether support or resources are likely to gather",
                        "whether it is wise to proceed, wait, or reconsider",
                        "how to understand the conditions around illness, obstacles, or practice"
                    ]
                ),
                EditorialSection(
                    title: "How to Phrase the Question",
                    body: [
                        "The best questions are usually simple and inwardly phrased, such as:"
                    ],
                    bullets: [
                        "What are the conditions around this relationship?",
                        "Is it favorable to proceed with this plan?",
                        "How is this undertaking likely to unfold?",
                        "What should I understand about this obstacle?",
                        "What are the conditions around my health in this matter?",
                        "Is this the right time to move forward?",
                        "What is the outlook for this aspiration?",
                        "How should I understand this situation in my spiritual practice?"
                    ],
                    closingTitle: "Questions are usually less helpful when phrased as:",
                    closingBullets: [
                        "Will I definitely get exactly what I want?",
                        "Does this person secretly love me?",
                        "Will everything turn out perfectly?",
                        "What is going to happen to my whole life?"
                    ],
                    closing: "These are either too absolute, too speculative, or too broad. They leave little room for interpretation and often invite wishfulness rather than clarity."
                ),
                EditorialSection(
                    title: "Ask One Question at a Time",
                    body: [
                        "If several concerns are entangled, choose the one that most needs light.",
                        "One clear question leads to one interpretable answer."
                    ],
                    bulletsTitle: "Not:",
                    bullets: [
                        "Should I move, leave my relationship, change jobs, and start a new practice?"
                    ],
                    followUpTitle: "But rather:",
                    followUpBullets: [
                        "Is it favorable to make this move now?",
                        "What are the conditions around this relationship now?",
                        "What is the outlook for this work decision?"
                    ]
                ),
                EditorialSection(
                    title: "Ask About Conditions, Not Control",
                    body: [
                        "The Mo is best consulted to understand conditions, not to seize certainty.",
                        "Rather than forcing the future into a yes-or-no demand, ask in a way that allows wisdom to show:",
                        "This is why many of the results make the most sense when the question has to do with outlook, alignment, timing, health, prosperity, spiritual obstacles, or the strength of an undertaking."
                    ],
                    bullets: [
                        "whether the path is open or obstructed",
                        "whether support is present or lacking",
                        "whether the matter is ripening or declining",
                        "whether caution, patience, or confidence is called for"
                    ]
                ),
                EditorialSection(
                    title: "Receive the Answer Properly",
                    body: [
                        "After the cast, do not rush to bend the answer to your preference.",
                        "Read it slowly. Let the main tone register first. Notice what it says about strength or weakness, support or depletion, harmony or conflict, health or imbalance, prosperity or erosion, clarity or confusion. Then notice which part of your question it seems to illuminate most directly.",
                        "Sometimes the answer confirms what you already sensed. Sometimes it reframes the situation. Sometimes it does not flatter your hopes. All of this is part of the practice."
                    ]
                ),
                EditorialSection(
                    title: "A Final Word on Confidence",
                    body: [
                        "The usefulness of the Mo depends less on intensity than on sincerity.",
                        "You do not need to strain. You do not need to perform certainty. You do not need to ask dramatically.",
                        "You need:",
                        "Consult the Mo with reverence, simplicity, and honesty.",
                        "Then let the answer speak."
                    ],
                    bullets: [
                        "a settled mind",
                        "a clear question",
                        "a sincere intention",
                        "a willingness to receive what is shown"
                    ]
                )
            ]
        )
    }
}

private struct EditorialSection {
    let title: String
    let body: [String]
    var bulletsTitle: String?
    var bullets: [String] = []
    var followUpTitle: String?
    var followUpBullets: [String] = []
    var closingTitle: String?
    var closingBullets: [String] = []
    var closing: String?
}

private struct EditorialArticleView: View {
    let title: String?
    let sections: [EditorialSection]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 28) {
                if let title {
                    Text(title)
                        .font(MoTheme.headingFont(size: 42))
                        .foregroundStyle(MoTheme.primaryText)
                        .padding(.top, 12)
                }

                ForEach(Array(sections.enumerated()), id: \.offset) { index, section in
                    VStack(alignment: .leading, spacing: 16) {
                        Text(section.title)
                            .font(MoTheme.bodyFont(size: 15).weight(.semibold))
                            .tracking(2.8)
                            .foregroundStyle(MoTheme.accent)

                        ForEach(section.body, id: \.self) { paragraph in
                            Text(paragraph)
                                .font(MoTheme.bodyFont(size: 19))
                                .foregroundStyle(MoTheme.primaryText.opacity(0.96))
                                .lineSpacing(7)
                        }

                        if !section.bullets.isEmpty {
                            if let bulletsTitle = section.bulletsTitle {
                                Text(bulletsTitle)
                                    .font(MoTheme.bodyFont(size: 18).weight(.medium))
                                    .foregroundStyle(MoTheme.secondaryText)
                                    .padding(.top, 2)
                            }

                            bulletList(section.bullets)
                        }

                        if !section.followUpBullets.isEmpty {
                            if let followUpTitle = section.followUpTitle {
                                Text(followUpTitle)
                                    .font(MoTheme.bodyFont(size: 18).weight(.medium))
                                    .foregroundStyle(MoTheme.secondaryText)
                                    .padding(.top, 2)
                            }

                            bulletList(section.followUpBullets)
                        }

                        if let closingTitle = section.closingTitle {
                            Text(closingTitle)
                                .font(MoTheme.bodyFont(size: 18).weight(.medium))
                                .foregroundStyle(MoTheme.secondaryText)
                                .padding(.top, 2)
                        }

                        if !section.closingBullets.isEmpty {
                            bulletList(section.closingBullets)
                        }

                        if let closing = section.closing {
                            Text(closing)
                                .font(MoTheme.bodyFont(size: 19))
                                .foregroundStyle(MoTheme.primaryText.opacity(0.96))
                                .lineSpacing(7)
                        }
                    }
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(MoTheme.cardBackground)
                            .shadow(color: MoTheme.shadow, radius: 14, x: 0, y: 8)
                    )

                    if index < sections.count - 1 {
                        Divider()
                            .overlay(MoTheme.secondaryText.opacity(0.16))
                            .padding(.horizontal, 10)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 42)
        }
        .background(MoTheme.background.ignoresSafeArea())
    }

    private func bulletList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                Text("• \(item)")
                    .font(MoTheme.bodyFont(size: 18))
                    .foregroundStyle(MoTheme.primaryText.opacity(0.95))
                    .lineSpacing(5)
            }
        }
        .padding(.leading, 2)
    }
}

struct EntriesView: View {
    @State private var searchText = ""

    private let entries: [MoEntry] = {
        let loaded = (try? MoEntryLoader.loadEntries()) ?? []
        return loaded.sorted { $0.id < $1.id }
    }()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                Text("The 36 Divinations")
                    .font(MoTheme.headingFont(size: 40))
                    .foregroundStyle(MoTheme.primaryText)
                    .padding(.top, 12)

                Text("A reference for study and familiarity. Browse the full cycle without entering the ritual flow.")
                    .font(MoTheme.bodyFont(size: 18))
                    .foregroundStyle(MoTheme.secondaryText)
                    .lineSpacing(6)

                if !entries.isEmpty {
                    TextField("Search titles or syllables", text: $searchText)
                        .font(MoTheme.bodyFont(size: 17))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(MoTheme.cardBackground)
                                .shadow(color: MoTheme.shadow, radius: 10, x: 0, y: 5)
                        )
                }

                LazyVStack(spacing: 14) {
                    ForEach(filteredEntries) { entry in
                        NavigationLink {
                            EntryDetailView(entry: entry)
                        } label: {
                            EntryRowView(entry: entry)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 36)
        }
        .background(MoTheme.background.ignoresSafeArea())
    }

    private var filteredEntries: [MoEntry] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return entries }

        return entries.filter { entry in
            entry.title.localizedCaseInsensitiveContains(query)
            || entry.key.localizedCaseInsensitiveContains(query)
            || entry.syllables.joined(separator: " ").localizedCaseInsensitiveContains(query)
        }
    }
}

private struct EntryRowView: View {
    let entry: MoEntry

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text(entry.title)
                    .font(MoTheme.bodyFont(size: 20).weight(.medium))
                    .foregroundStyle(MoTheme.primaryText)
                    .multilineTextAlignment(.leading)

                Text(entry.syllables.joined(separator: " • "))
                    .font(MoTheme.bodyFont(size: 15).weight(.medium))
                    .tracking(1.8)
                    .foregroundStyle(MoTheme.accent)

                Text(entry.overallTone.uppercased())
                    .font(MoTheme.bodyFont(size: 12).weight(.semibold))
                    .tracking(2.4)
                    .foregroundStyle(MoTheme.secondaryText)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(MoTheme.secondaryText.opacity(0.7))
                .padding(.top, 4)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(MoTheme.cardBackground)
                .shadow(color: MoTheme.shadow, radius: 12, x: 0, y: 6)
        )
    }
}

struct EntryDetailView: View {
    let entry: MoEntry

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 28) {
                VStack(spacing: 18) {
                    HStack(spacing: 24) {
                        ForEach(Array(entry.syllables.enumerated()), id: \.offset) { item in
                            MoTokenView(
                                diceValue: entry.dice[item.offset],
                                syllable: item.element,
                                showsLabel: true,
                                size: 96
                            )
                        }
                    }
                    .padding(.top, 8)

                    VStack(spacing: 10) {
                        Text(entry.title)
                            .font(MoTheme.headingFont(size: 42))
                            .foregroundStyle(MoTheme.primaryText.opacity(0.84))
                            .multilineTextAlignment(.center)

                        Text(entry.overallTone.uppercased())
                            .font(MoTheme.bodyFont(size: 16).weight(.medium))
                            .tracking(4)
                            .foregroundStyle(MoTheme.accent)
                    }
                    .padding(.top, 8)
                }

                SummaryCardView(entry: entry)
                InterpretationCardView(entry: entry)
            }
            .padding(.horizontal, 24)
            .padding(.top, 18)
            .padding(.bottom, 42)
        }
        .background(MoTheme.background.ignoresSafeArea())
    }
}
