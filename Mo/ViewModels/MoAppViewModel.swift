import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

enum MoRitualTiming {
    static let primaryCastDuration = 3.0
    static let pauseDuration = 0.75
    static let secondaryCastDuration = 2.25
    static let settleDuration = 2.25

    static let totalDuration: Duration = .seconds(
        primaryCastDuration + pauseDuration + secondaryCastDuration + settleDuration
    )
}

@MainActor
final class MoAppViewModel: ObservableObject {
    static let ritualDuration = MoRitualTiming.totalDuration

    enum Screen {
        case home
        case ritual
        case result
    }

    @Published private(set) var screen: Screen = .home
    @Published private(set) var currentReading: MoReading?
    @Published private(set) var ritualPrimaryCast: MoCastPair = .placeholder
    @Published private(set) var ritualSecondaryCast: MoCastPair = .placeholder
    @Published private(set) var ritualSessionID = UUID()

    private let repository: MoRepository
    private var pendingReading: MoReading?

    init(repository: MoRepository) {
        self.repository = repository
    }

    static func makeLive() -> MoAppViewModel {
        do {
            let entries = try MoEntryLoader.loadEntries()
            let repository = try MoRepository(entries: entries)
            return MoAppViewModel(repository: repository)
        } catch {
            fatalError("Failed to bootstrap Mo app data: \(error.localizedDescription)")
        }
    }

    func beginRitual() {
        currentReading = nil
        pendingReading = makePendingReading()
        ritualPrimaryCast = pendingReading?.primaryCast ?? .placeholder
        ritualSecondaryCast = pendingReading?.secondaryCast ?? .placeholder
        ritualSessionID = UUID()

        withAnimation(.easeInOut(duration: 0.6)) {
            screen = .ritual
        }
    }

    func performRitual(for sessionID: UUID) async {
        do {
            try await Task.sleep(for: Self.ritualDuration)
        } catch {
            return
        }

        guard !Task.isCancelled, sessionID == ritualSessionID else {
            return
        }

        guard let reading = pendingReading else {
            assertionFailure("Missing pending reading for ritual session: \(sessionID)")
            return
        }

        currentReading = reading
        pendingReading = nil
        emitHaptic()

        withAnimation(.easeInOut(duration: 0.7)) {
            screen = .result
        }
    }

    func returnHome() {
        currentReading = nil
        pendingReading = nil
        ritualPrimaryCast = .placeholder
        ritualSecondaryCast = .placeholder

        withAnimation(.easeInOut(duration: 0.6)) {
            screen = .home
        }
    }

    private func makePendingReading() -> MoReading? {
        for _ in 0..<50 {
            let primaryCast = repository.castPair(for: [Int.random(in: 1...6), Int.random(in: 1...6)])
            let secondaryCast = repository.castPair(for: [Int.random(in: 1...6), Int.random(in: 1...6)])
            let firmness = MoFirmnessEvaluator.evaluate(primary: primaryCast, secondary: secondaryCast)

            if let reading = repository.reading(
                primaryCast: primaryCast,
                secondaryCast: secondaryCast,
                firmness: firmness
            ) {
                return reading
            }
        }

        return nil
    }

    private func emitHaptic() {
        #if canImport(UIKit)
        let generator = UIImpactFeedbackGenerator(style: .soft)
        generator.prepare()
        generator.impactOccurred(intensity: 0.8)
        #endif
    }
}

extension MoAppViewModel {
    static let previewEntry = MoEntry(
        id: 12,
        key: "RA_DHI",
        dice: [2, 1],
        syllables: ["RA", "DHI"],
        title: "The Door of Auspicious Visions",
        overallTone: "favorable",
        summary: "A good sign of guidance, insight, and beneficial openings. Success comes through good counsel and wise alignment.",
        interpretation: Interpretation(
            general: "This reading supports growth through vision, instruction, and spiritual or intuitive clarity.",
            favorableFor: ["guidance", "omens", "divination", "creative insight"],
            caution: "Success improves when you listen to trustworthy advice rather than acting impulsively."
        )
    )

    static func makePreview() -> MoAppViewModel {
        let repository = try! MoRepository(entries: [previewEntry])
        return MoAppViewModel(repository: repository)
    }

    func loadPreviewReading() {
        let primaryCast = MoCastPair(diceValues: [2, 1], syllables: ["RA", "DHI"], key: "RA_DHI")
        let secondaryCast = MoCastPair(diceValues: [3, 6], syllables: ["PA", "AH"], key: "PA_AH")

        currentReading = MoReading(
            primaryCast: primaryCast,
            secondaryCast: secondaryCast,
            firmness: .standard,
            entry: Self.previewEntry
        )
        screen = .result
    }
}
