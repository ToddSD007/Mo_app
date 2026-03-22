import SwiftUI

struct MoTokenView: View {
    let syllable: String?
    var showsLabel: Bool = false
    var size: CGFloat = 104
    var isAnimating: Bool = false

    @State private var shimmerOffset: CGFloat = -160

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
                    .frame(width: size * 0.34, height: size * 0.34)

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
                .degrees(isAnimating ? 360 : 0),
                axis: (x: 0.35, y: 1, z: 0),
                perspective: 0.55
            )
            .animation(.easeInOut(duration: 3), value: isAnimating)

            if showsLabel, let syllable {
                Text(syllable)
                    .font(MoTheme.bodyFont(size: 18).weight(.medium))
                    .tracking(2.8)
                    .foregroundStyle(MoTheme.accent)
            }
        }
        .task(id: isAnimating) {
            guard isAnimating else {
                shimmerOffset = -160
                return
            }

            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: false)) {
                shimmerOffset = 160
            }
        }
    }
}

struct MoTokenView_Previews: PreviewProvider {
    static var previews: some View {
        MoTokenView(syllable: "RA", showsLabel: true, isAnimating: true)
            .padding()
            .background(MoTheme.background)
    }
}
