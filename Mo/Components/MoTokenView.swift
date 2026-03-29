import SwiftUI

struct MoTokenView: View {
    let diceValue: Int?
    let syllable: String?
    var showsLabel: Bool = false
    var size: CGFloat = 104
    var isAnimating: Bool = false

    @State private var animatedValue = 1
    @State private var shimmerOffset: CGFloat = -160
    @State private var glyphOpacity = 0.3
    @State private var glyphScale = 0.92

    private let animation = TokenAnimationConfig()

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .fill(Color.white.opacity(0.96))
                    .shadow(color: MoTheme.shadow, radius: 14, x: 0, y: 6)

                Circle()
                    .fill(
                        LinearGradient(
                            colors: [MoTheme.accentSoft, MoTheme.accent],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: size * 0.65, height: size * 0.65)

                Text(faceScript)
                    .font(MoTheme.headingFont(size: size * 0.4))
                    .foregroundStyle(MoTheme.primaryText.opacity(glyphOpacity))
                    .scaleEffect(glyphScale)
                    .blur(radius: isAnimating ? (1 - glyphOpacity) * 1.6 : 0)

                if isAnimating {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    Color.white.opacity(0.15),
                                    Color.white.opacity(0.82),
                                    Color.white.opacity(0.15),
                                    .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .rotationEffect(.degrees(20))
                        .offset(x: shimmerOffset)
                        .blendMode(.screen)
                        .mask {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                        }
                }
            }
            .frame(width: size, height: size)
            .rotation3DEffect(
                .degrees(isAnimating ? 720 : 0),
                axis: (x: 0.25, y: 1, z: 0.5),
                perspective: 0.1
            )
            .animation(.easeInOut(duration: animation.tokenRotationDuration), value: isAnimating)

            if showsLabel, let labelSyllable {
                Text(labelSyllable)
                    .font(MoTheme.bodyFont(size: 18).weight(.medium))
                    .tracking(2.8)
                    .foregroundStyle(MoTheme.accent)
            }
        }
        .task(id: isAnimating) {
            await animateFaceIfNeeded()
        }
    }

    private var resolvedValue: Int {
        let resolved = diceValue ?? DiceFace.value(for: syllable) ?? 1
        return min(max(resolved, 1), 6)
    }

    private var visibleValue: Int {
        isAnimating ? animatedValue : resolvedValue
    }

    private var faceScript: String {
        DiceFace.script(for: visibleValue)
    }

    private var labelSyllable: String? {
        syllable ?? DiceFace.transliteration(for: resolvedValue)
    }

    @MainActor
    private func animateFaceIfNeeded() async {
        guard isAnimating else {
            animatedValue = resolvedValue
            shimmerOffset = -160
            glyphOpacity = 0.92
            glyphScale = 1
            return
        }

        animatedValue = Int.random(in: 1...6)
        shimmerOffset = -160
        glyphOpacity = 0.3
        glyphScale = 0.92

        withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: false)) {
            shimmerOffset = 160
        }

        let clock = ContinuousClock()
        let endTime = clock.now.advanced(by: .seconds(animation.glyphLoopDuration))

        try? await Task.sleep(for: .seconds(Double.random(in: 0 ... 0.45)))

        while isAnimating && !Task.isCancelled && clock.now < endTime {
            withAnimation(.easeInOut(duration: 0.42)) {
                glyphOpacity = 0.96
                glyphScale = 1.06
            }

            try? await Task.sleep(for: .seconds(Double.random(in: 0.32 ... 0.5)))

            guard isAnimating, !Task.isCancelled else { break }

            withAnimation(.easeInOut(duration: 0.28)) {
                glyphOpacity = 0.34
                glyphScale = 0.9
            }

            try? await Task.sleep(for: .seconds(Double.random(in: 0.16 ... 0.3)))

            guard isAnimating, !Task.isCancelled else { break }

            withAnimation(.easeInOut(duration: 0.18)) {
                animatedValue = DiceFace.randomValue(excluding: animatedValue)
            }
        }

        withAnimation(.easeInOut(duration: 0.4)) {
            animatedValue = resolvedValue
            glyphOpacity = 0.92
            glyphScale = 1
        }
    }
}

private struct TokenAnimationConfig {
    // Keep these aligned so the glyph loop ends when the token rotation ends.
    // Current: 5.0. Suggested range: 3.0...7.0
    let tokenRotationDuration = 5.0

    // Current: 5.0. Suggested range: 3.0...7.0
    let glyphLoopDuration = 5.0
}

private enum DiceFace {
    private static let transliterations: [Int: String] = [
        1: "DHI",
        2: "RA",
        3: "PA",
        4: "NA",
        5: "TSA",
        6: "AH"
    ]

    private static let scripts: [Int: String] = [
        1: "དྷཱི",
        2: "ར",
        3: "པ",
        4: "ན",
        5: "ཙ",
        6: "ཨ"
    ]

    private static let valueBySyllable: [String: Int] = [
        "DHI": 1,
        "RA": 2,
        "PA": 3,
        "NA": 4,
        "TSA": 5,
        "AH": 6
    ]

    static func transliteration(for value: Int) -> String {
        transliterations[value, default: "DHI"]
    }

    static func script(for value: Int) -> String {
        scripts[value, default: "དྷཱིཿ"]
    }

    static func value(for syllable: String?) -> Int? {
        guard let syllable else { return nil }
        return valueBySyllable[syllable.uppercased()]
    }

    static func randomValue(excluding value: Int) -> Int {
        let candidates = (1...6).filter { $0 != value }
        return candidates.randomElement() ?? value
    }
}

struct MoTokenView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 24) {
            MoTokenView(diceValue: 2, syllable: "RA", showsLabel: true, isAnimating: false)
            MoTokenView(diceValue: 5, syllable: "TSA", showsLabel: true, isAnimating: true)
        }
        .padding()
        .background(MoTheme.background)
    }
}
