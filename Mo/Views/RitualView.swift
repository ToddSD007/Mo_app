import SwiftUI

struct RitualView: View {
    @ObservedObject var viewModel: MoAppViewModel

    @State private var mantraRotation = 0.0
    @State private var animateTokens = false

    private let tibetanMantra = "ཨོཾ་ཨ་ར་པ་ཙ་ན་དྷཱིཿ"

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

                Text(tibetanMantra)
                    .font(MoTheme.headingFont(size: 52))
                    .foregroundStyle(MoTheme.accent)
                    .multilineTextAlignment(.center)
                    .rotationEffect(.degrees(mantraRotation))
                    .frame(maxWidth: 320)

                Text("OM AH RA PA TSA NA DHI")
                    .font(MoTheme.bodyFont(size: 20).weight(.medium))
                    .tracking(4.2)
                    .foregroundStyle(MoTheme.secondaryText.opacity(0.4))
                    .multilineTextAlignment(.center)

                HStack(spacing: 28) {
                    MoTokenView(syllable: nil, size: 118, isAnimating: animateTokens)
                    MoTokenView(syllable: nil, size: 118, isAnimating: animateTokens)
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
            await viewModel.performRitual(for: viewModel.ritualSessionID)
        }
        .onAppear {
            mantraRotation = 0
            animateTokens = false

            withAnimation(.easeInOut(duration: 18).repeatForever(autoreverses: false)) {
                mantraRotation = 360
            }

            withAnimation(.easeInOut(duration: 3)) {
                animateTokens = true
            }
        }
    }
}

struct RitualView_Previews: PreviewProvider {
    static var previews: some View {
        RitualView(viewModel: .makePreview())
    }
}
