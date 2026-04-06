import SwiftUI

struct RitualView: View {
    @ObservedObject var viewModel: MoAppViewModel

    @State private var animatePrimaryTokens = false
    @State private var animateSecondaryTokens = false
    @State private var animateGlow = false
    @State private var wheelRotation = 0.0
    @State private var displayedPrimaryCast: MoCastPair = .placeholder
    @State private var displayedSecondaryCast: MoCastPair = .placeholder
    @State private var showsSecondaryCast = false
    @State private var ritualStage: RitualStage = .primary

    private let layout = RitualLayoutConfig()
    private let wheelSyllables = ["ཨོཾ", "ཨ", "ར", "པ", "ཙ", "ན"]
    private let centerSyllable = "དྷཱི"
    private let wheelRadius: CGFloat = 80
    private let wheelGlyphSize: CGFloat = 42
    private let centerGlyphSize: CGFloat = 68
    private let wheelGlowRadius: CGFloat = 48

    var body: some View {
        ZStack {
            MoTheme.background
                .ignoresSafeArea()

            VStack(spacing: layout.verticalStackSpacing) {
                Spacer(minLength: layout.topSpacerMinHeight)

                Text("THE MANTRA OF MANJUSHRI")
                    .font(MoTheme.bodyFont(size: 17).weight(.medium))
                    .tracking(5.6)
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: layout.headerMaxWidth)
                    .padding(.top, layout.headerTopPadding)

                ZStack {
                    ZStack {
                        ForEach(Array(wheelSyllables.enumerated()), id: \.offset) { index, syllable in
                            let angle = Angle.degrees(Double(index) * (360.0 / Double(wheelSyllables.count)) - 90)

                            ZStack {
                                Text(syllable)
                                    .font(MoTheme.headingFont(size: wheelGlyphSize))
                                    .foregroundStyle(Color(hex: 0xF6E7B7).opacity(animateGlow ? 0.95 : 0.45))
                                    .blur(radius: animateGlow ? wheelGlowRadius * 0.44 : wheelGlowRadius * 0.16)

                                Text(syllable)
                                    .font(MoTheme.headingFont(size: wheelGlyphSize))
                                    .foregroundStyle(wheelGlyphColor)
                                    .shadow(color: MoTheme.accent.opacity(0.28), radius: 8, x: 0, y: 2)
                            }
                                .rotationEffect(.degrees(0))
                                .offset(y: -wheelRadius)
                                .rotationEffect(angle)
                        }
                    }
                    .rotationEffect(.degrees(wheelRotation))

                    Text(centerSyllable)
                        .font(MoTheme.headingFont(size: centerGlyphSize))
                        .foregroundStyle(wheelGlyphColor)
                        .shadow(color: MoTheme.accent.opacity(animateGlow ? 0.25 : 0.18), radius: 14, x: 0, y: 4)
                }
                .frame(width: layout.wheelFrameSize, height: layout.wheelFrameSize)
                .multilineTextAlignment(.center)

                Text("OM AH RA PA TSA NA DHI")
                    .font(MoTheme.bodyFont(size: 20).weight(.medium))
                    .tracking(4.2)
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.4))
                    .multilineTextAlignment(.center)

                Text("Consulting the wisdom...")
                    .font(MoTheme.bodyFont(size: 18))
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.75))
                    .padding(.top, layout.consultingTopPadding)

                VStack(spacing: layout.castSectionSpacing) {
                    castSection(
                        title: "PRIMARY CAST",
                        cast: displayedPrimaryCast,
                        isAnimating: animatePrimaryTokens,
                        animationDuration: MoRitualTiming.primaryCastDuration,
                        showsSection: true
                    )

                    castSection(
                        title: "FIRMNESS CAST",
                        cast: displayedSecondaryCast,
                        isAnimating: animateSecondaryTokens,
                        animationDuration: MoRitualTiming.secondaryCastDuration,
                        showsSection: showsSecondaryCast
                    )
                }
                .padding(.top, layout.castSectionTopPadding)

                Text(ritualStage.message)
                    .font(MoTheme.bodyFont(size: 18))
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.75))
                    .padding(.top, layout.stageMessageTopPadding)

                Spacer(minLength: layout.bottomSpacerMinHeight)
            }
            .padding(.horizontal, 28)
            .padding(.vertical, layout.verticalPadding)
        }
        .task(id: viewModel.ritualSessionID) {
            async let ritualTask: Void = viewModel.performRitual(for: viewModel.ritualSessionID)
            runWheelAnimation()
            await runRitualAnimation()
            _ = await ritualTask
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var wheelGlyphColor: some ShapeStyle {
        LinearGradient(
            colors: [
                Color(hex: 0xF2DC9B),
                MoTheme.accent,
                Color(hex: 0xC89A32)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    @ViewBuilder
    private func castSection(
        title: String,
        cast: MoCastPair,
        isAnimating: Bool,
        animationDuration: Double,
        showsSection: Bool
    ) -> some View {
        VStack(spacing: 12) {
            Text(title)
                .font(MoTheme.bodyFont(size: 13).weight(.semibold))
                .tracking(2.4)
                .foregroundStyle(MoTheme.secondaryText.opacity(0.62))

            HStack(spacing: 24) {
                MoTokenView(
                    diceValue: cast.diceValues.count > 0 ? cast.diceValues[0] : 1,
                    syllable: nil,
                    size: 104,
                    isAnimating: isAnimating,
                    animationDuration: animationDuration
                )
                MoTokenView(
                    diceValue: cast.diceValues.count > 1 ? cast.diceValues[1] : 1,
                    syllable: nil,
                    size: 104,
                    isAnimating: isAnimating,
                    animationDuration: animationDuration
                )
            }
        }
        .opacity(showsSection ? 1 : 0)
        .offset(y: showsSection ? 0 : 12)
        .animation(.easeInOut(duration: 0.35), value: showsSection)
    }

    private func runWheelAnimation() {
        wheelRotation = 0

        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            wheelRotation = -360
        }
    }

    private func runRitualAnimation() async {
        animatePrimaryTokens = false
        animateSecondaryTokens = false
        animateGlow = false
        ritualStage = .primary
        displayedPrimaryCast = viewModel.ritualPrimaryCast
        displayedSecondaryCast = viewModel.ritualSecondaryCast
        showsSecondaryCast = false

        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            animateGlow = true
        }

        withAnimation(.easeInOut(duration: MoRitualTiming.primaryCastDuration)) {
            animatePrimaryTokens = true
        }
        try? await Task.sleep(for: .seconds(MoRitualTiming.primaryCastDuration))

        withAnimation(.easeInOut(duration: 0.25)) {
            animatePrimaryTokens = false
            ritualStage = .transition
        }
        try? await Task.sleep(for: .seconds(MoRitualTiming.pauseDuration))

        withAnimation(.easeInOut(duration: 0.25)) {
            showsSecondaryCast = true
            ritualStage = .secondary
        }

        withAnimation(.easeInOut(duration: MoRitualTiming.secondaryCastDuration)) {
            animateSecondaryTokens = true
        }
        try? await Task.sleep(for: .seconds(MoRitualTiming.secondaryCastDuration))

        withAnimation(.easeInOut(duration: 0.25)) {
            animateSecondaryTokens = false
            ritualStage = .settling
        }
        try? await Task.sleep(for: .seconds(MoRitualTiming.settleDuration))
    }
}

private struct RitualLayoutConfig {
    // Space between the major sections in the main vertical stack.
    // Original/current value: 18
    let verticalStackSpacing: CGFloat = 12

    // Extra space above the title and wheel content. Lower this to move everything upward.
    // Original/current value: 86
    let topSpacerMinHeight: CGFloat = 20

    // Maximum width for the "THE MANTRA OF MANJUSHRI" header before it wraps.
    // Original/current value: 260
    let headerMaxWidth: CGFloat = 260

    // Additional top padding on the header text itself.
    // Original/current value: 10
    let headerTopPadding: CGFloat = 1

    // Width/height of the wheel container. Reducing this gives more room to the content below.
    // Original/current value: 300
    let wheelFrameSize: CGFloat = 225

    // Extra space above "Consulting the wisdom..."
    // Original/current value: 4
    let consultingTopPadding: CGFloat = 2

    // Space between the primary cast and firmness cast sections.
    // Original/current value: 18
    let castSectionSpacing: CGFloat = 18

    // Space above the cast section block.
    // Original/current value: 16
    let castSectionTopPadding: CGFloat = 12

    // Space above the ritual stage message at the bottom.
    // Original/current value: 4
    let stageMessageTopPadding: CGFloat = 4

    // Bottom spacer under the ritual stage message. Lower this to pull content down less.
    // Original/current value: 12
    let bottomSpacerMinHeight: CGFloat = 8

    // Overall vertical padding for the page content.
    // Original/current value: 24
    let verticalPadding: CGFloat = 24
}

private enum RitualStage {
    case primary
    case transition
    case secondary
    case settling

    var message: String {
        switch self {
        case .primary:
            return "Receiving the first answer..."
        case .transition:
            return "Holding the answer in stillness..."
        case .secondary:
            return "Confirming the firmness..."
        case .settling:
            return "Seeking guidance..."
        }
    }
}

struct RitualView_Previews: PreviewProvider {
    static var previews: some View {
        RitualView(viewModel: .makePreview())
    }
}
