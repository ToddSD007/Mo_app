import SwiftUI

struct RitualView: View {
    @ObservedObject var viewModel: MoAppViewModel

    @State private var animateTokens = false
    @State private var animateGlow = false
    @State private var wheelRotation = 0.0

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

            VStack(spacing: 30) {
                Spacer(minLength: 40)

                Text("THE MANTRA OF MANJUSHRI")
                    .font(MoTheme.bodyFont(size: 17).weight(.medium))
                    .tracking(5.6)
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 260)

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
                .frame(width: 340, height: 340)
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
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.75))
                    .padding(.top, 18)

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 32)
        }
        .task(id: viewModel.ritualSessionID) {
            async let ritualTask: Void = viewModel.performRitual(for: viewModel.ritualSessionID)
            runWheelAnimation()
            await runRitualAnimation()
            _ = await ritualTask
        }
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

    private func runWheelAnimation() {
        wheelRotation = 0

        withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
            wheelRotation = 360
        }
    }

    private func runRitualAnimation() async {
        animateTokens = false
        animateGlow = false

        withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
            animateGlow = true
        }

        withAnimation(.easeInOut(duration: 3)) {
            animateTokens = true
        }
        try? await Task.sleep(for: .seconds(0.1))
    }
}

struct RitualView_Previews: PreviewProvider {
    static var previews: some View {
        RitualView(viewModel: .makePreview())
    }
}
