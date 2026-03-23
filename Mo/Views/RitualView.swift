import SwiftUI

struct RitualView: View {
    @ObservedObject var viewModel: MoAppViewModel

    @State private var animateTokens = false
    @State private var animateGlow = false
    @State private var syllableOpacities = Array(repeating: 0.0, count: 7)

    private let animation = MantraAnimationConfig()
    private let mantraSyllables = ["ཨོཾ", "ཨ", "ར", "པ", "ཙ", "ན", "དྷཱིཿ  "]

    var body: some View {
        ZStack {
            MoTheme.background
                .ignoresSafeArea()

            VStack(spacing: 30) {
                Spacer(minLength: 40)

                Text("THE MANTRA OF MANJUSHRI")
                    .font(MoTheme.bodyFont(size: 17).weight(.medium))
                    .tracking(5.6)
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.6))
                    .multilineTextAlignment(.center)

                HStack(spacing: 0) {
                    ForEach(Array(mantraSyllables.enumerated()), id: \.offset) { index, syllable in
                        Text(index == mantraSyllables.count - 1 ? syllable : "\(syllable)་")
                            .opacity(syllableOpacities[index])
                    }
                }
                .font(MoTheme.headingFont(size: 52))
                .foregroundStyle(MoTheme.accent)
                .shadow(
                    color: MoTheme.accent.opacity(animateGlow ? 0.55 : 0.22),
                    radius: animateGlow ? 22 : 10
                )
                .frame(maxWidth: 360, minHeight: 140)
                .multilineTextAlignment(.center)

                Text("OM AH RA PA TSA NA DHI")
                    .font(MoTheme.bodyFont(size: 20).weight(.medium))
                    .tracking(4.2)
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.4))
                    .multilineTextAlignment(.center)

                HStack(spacing: 28) {
                    MoTokenView(diceValue: 1, syllable: nil, size: 118, isAnimating: animateTokens)
                    MoTokenView(diceValue: 1, syllable: nil, size: 118, isAnimating: animateTokens)
                }
                .padding(.top, 16)

                Text("Consulting the wisdom...")
                    .font(MoTheme.bodyFont(size: 18))
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.25))
                    .padding(.top, 18)

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 36)
        }
        .task(id: viewModel.ritualSessionID) {
            async let ritualTask: Void = viewModel.performRitual(for: viewModel.ritualSessionID)
            await runMantraAnimation()
            _ = await ritualTask
        }
    }

    private func runMantraAnimation() async {
        animateTokens = false
        animateGlow = false
        syllableOpacities = Array(repeating: animation.hiddenOpacity, count: mantraSyllables.count)

        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            animateGlow = true
        }

        withAnimation(.easeInOut(duration: 3)) {
            animateTokens = true
        }

        for _ in 0..<2 {
            for index in mantraSyllables.indices {
                guard !Task.isCancelled else { return }

                withAnimation(.easeInOut(duration: animation.syllableFadeInDuration)) {
                    syllableOpacities[index] = animation.visibleOpacity
                }
                try? await Task.sleep(
                    for: .seconds(animation.syllableFadeInDuration + animation.syllableHoldDuration)
                )

                withAnimation(.easeInOut(duration: animation.syllableFadeOutDuration)) {
                    syllableOpacities[index] = animation.hiddenOpacity
                }
                try? await Task.sleep(for: .seconds(animation.syllableFadeOutDuration))
            }
        }

        for index in mantraSyllables.indices {
            guard !Task.isCancelled else { return }

            withAnimation(.easeInOut(duration: animation.finalRevealDuration)) {
                syllableOpacities[index] = animation.visibleOpacity
            }
            try? await Task.sleep(
                for: .seconds(animation.finalRevealDuration + animation.finalRevealHoldDuration)
            )
        }
    }
}

private struct MantraAnimationConfig {
    // Current: 1.0. Suggested range: 0.85...1.0
    let visibleOpacity = 1.0

    // Current: 0.06. Suggested range: 0.0...0.15
    let hiddenOpacity = 0.04

    // Current: 0.2. Suggested range: 0.15...0.45
    let syllableFadeInDuration = 0.1

    // Current: 0.03. Suggested range: 0.0...0.12
    let syllableHoldDuration = 0.06

    // Current: 0.2. Suggested range: 0.15...0.45
    let syllableFadeOutDuration = 0.1

    // Current: 0.18. Suggested range: 0.12...0.35
    let finalRevealDuration = 0.13

    // Current: 0.02. Suggested range: 0.0...0.1
    let finalRevealHoldDuration = 0.15
}

struct RitualView_Previews: PreviewProvider {
    static var previews: some View {
        RitualView(viewModel: .makePreview())
    }
}
