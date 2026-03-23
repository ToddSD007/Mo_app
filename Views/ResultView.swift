import SwiftUI

struct ResultView: View {
    @ObservedObject var viewModel: MoAppViewModel

    var body: some View {
        ZStack {
            MoTheme.background
                .ignoresSafeArea()

            if let reading = viewModel.currentReading {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 28) {
                        header

                        VStack(spacing: 18) {
                            Text("DIVINATION RESULT")
                                .font(MoTheme.bodyFont(size: 18).weight(.medium))
                                .tracking(4.8)
                                .foregroundStyle(MoTheme.secondaryText.opacity(0.55))

                            HStack(spacing: 24) {
                                ForEach(Array(reading.syllables.enumerated()), id: \.offset) { item in
                                    MoTokenView(
                                        diceValue: reading.diceValues[item.offset],
                                        syllable: item.element,
                                        showsLabel: true,
                                        size: 96
                                    )
                                }
                            }
                            .padding(.top, 8)

                            VStack(spacing: 10) {
                                Text(reading.entry.title)
                                    .font(MoTheme.headingFont(size: 42))
                                    .foregroundStyle(MoTheme.primaryText.opacity(0.84))
                                    .multilineTextAlignment(.center)

                                Text(reading.entry.overallTone.uppercased())
                                    .font(MoTheme.bodyFont(size: 16).weight(.medium))
                                    .tracking(4)
                                    .foregroundStyle(MoTheme.accent)
                            }
                            .padding(.top, 8)
                        }

                        ResultCardView(reading: reading)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 18)
                    .padding(.bottom, 42)
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 4)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Button(action: viewModel.returnHome) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundStyle(MoTheme.secondaryText)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.7))
                    )
                    .overlay(
                        Circle()
                            .stroke(MoTheme.accent.opacity(0.1), lineWidth: 1)
                    )
            }

            Spacer()
        }
        .padding(.top, 8)
    }
}

struct ResultView_Previews: PreviewProvider {
    static var previews: some View {
        ResultPreviewContainer()
    }
}

private struct ResultPreviewContainer: View {
    let viewModel: MoAppViewModel = {
        let viewModel = MoAppViewModel.makePreview()
        viewModel.loadPreviewReading()
        return viewModel
    }()

    var body: some View {
        ResultView(viewModel: viewModel)
    }
}
