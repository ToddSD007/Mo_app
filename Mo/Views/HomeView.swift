import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: MoAppViewModel

    var body: some View {
        ZStack {
            Image("ManjushriBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.black.opacity(0.25),
                    Color.black.opacity(0.52),
                    Color.black.opacity(0.62)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 22) {
                Spacer()

                Text("Hold your question in your mind")
                    .font(MoTheme.headingFont(size: 34))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.96))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 3)
                    .padding(.horizontal, 28)

                Button(action: viewModel.beginRitual) {
                    Text("CAST")
                        .font(MoTheme.bodyFont(size: 22).weight(.semibold))
                        .tracking(1.5)
                        .foregroundStyle(.white.opacity(0.96))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.black.opacity(0.46))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .stroke(Color.white.opacity(0.78), lineWidth: 1.5)
                                )
                        )
                }
                .padding(.horizontal, 44)
                .padding(.bottom, 56)
            }
        }
        .statusBarHidden(false)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: .makePreview())
    }
}
