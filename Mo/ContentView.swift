import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel = MoAppViewModel.makeLive()
    @AppStorage("shouldSkipOnboarding") private var shouldSkipOnboarding = false

    @State private var navigationPath: [AppMenuDestination] = []
    @State private var showsMenu = false
    @State private var showsOnboarding = false
    @State private var hasHandledInitialOpen = false
    @State private var shouldPrepareOnNextActive = false

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
                case .readings:
                    SavedReadingsView(viewModel: viewModel)
                case .bringYourOwnDice:
                    BringYourOwnDiceView(viewModel: viewModel) {
                        navigationPath.append(.manualResult)
                    }
                case .manualResult:
                    ResultView(
                        viewModel: viewModel,
                        onOpenMenu: { showsMenu = true },
                        onReturn: {
                            navigationPath = []
                            viewModel.returnHome()
                        }
                    )
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
                handleInitialOpenIfNeeded()
            }
            .onChange(of: scenePhase) { _, newPhase in
                handleScenePhaseChange(newPhase)
            }
        }
    }

    private func handleInitialOpenIfNeeded() {
        guard !hasHandledInitialOpen else {
            return
        }

        hasHandledInitialOpen = true
        prepareForOpen()
    }

    private func handleScenePhaseChange(_ newPhase: ScenePhase) {
        switch newPhase {
        case .active:
            if shouldPrepareOnNextActive {
                prepareForOpen()
                shouldPrepareOnNextActive = false
            }
        case .inactive, .background:
            shouldPrepareOnNextActive = true
        @unknown default:
            break
        }
    }

    private func prepareForOpen() {
        navigationPath = []
        showsMenu = false
        viewModel.prepareForAppOpen()
        showsOnboarding = !shouldSkipOnboarding
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
