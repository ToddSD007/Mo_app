import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoAppViewModel.makeLive()

    var body: some View {
        ZStack {
            switch viewModel.screen {
            case .home:
                HomeView(viewModel: viewModel)
                    .transition(.opacity)
            case .ritual:
                RitualView(viewModel: viewModel)
                    .transition(.opacity)
            case .result:
                ResultView(viewModel: viewModel)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.6), value: viewModel.screen)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
