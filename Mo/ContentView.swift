import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MoAppViewModel.makeLive()
    @AppStorage("shouldSkipOnboarding") private var shouldSkipOnboarding = false

    @State private var navigationPath: [AppMenuDestination] = []
    @State private var showsMenu = false
    @State private var showsOnboarding = false

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                switch viewModel.screen {
                case .home:
                    HomeView(viewModel: viewModel, onOpenMenu: { showsMenu = true })
                        .transition(.opacity)
                case .ritual:
                    RitualView(viewModel: viewModel)
                        .transition(.opacity)
                case .result:
                    ResultView(viewModel: viewModel, onOpenMenu: { showsMenu = true })
                        .transition(.opacity)
                }
            }
            .animation(.easeInOut(duration: 0.6), value: viewModel.screen)
            .navigationDestination(for: AppMenuDestination.self) { destination in
                switch destination {
                case .introduction:
                    IntroductionView()
                case .howToConsult:
                    HowToConsultView()
                case .entries:
                    EntriesView()
                }
            }
            .sheet(isPresented: $showsMenu) {
                HomeMenuSheet { destination in
                    showsMenu = false
                    navigationPath.append(destination)
                }
            }
            .fullScreenCover(isPresented: $showsOnboarding) {
                OnboardingView { skipFutureLaunches in
                    shouldSkipOnboarding = skipFutureLaunches
                    showsOnboarding = false
                }
            }
            .onAppear {
                if !shouldSkipOnboarding {
                    showsOnboarding = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
