import Foundation
import SwiftUI

#if canImport(UIKit)
import UIKit
#endif

@MainActor
final class MoAppViewModel: ObservableObject {
    enum Screen {
        case home
        case ritual
        case result
    }

    @Published private(set) var screen: Screen = .home
    @Published private(set) var currentReading: MoReading?
    @Published private(set) var ritualSessionID = UUID()

    private let repository: MoRepository

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
        ritualSessionID = UUID()

        withAnimation(.easeInOut(duration: 0.6)) {
            screen = .ritual
        }
    }

    func performRitual(for sessionID: UUID) async {
        do {
            try await Task.sleep(for: .seconds(3))
        } catch {
            return
        }

        guard !Task.isCancelled, sessionID == ritualSessionID else {
            return
        }

        let diceValues = [Int.random(in: 1...6), Int.random(in: 1...6)]

        guard let reading = repository.reading(for: diceValues) else {
            assertionFailure("Missing Mo entry for dice values: \(diceValues)")
            return
        }

        currentReading = reading
        emitHaptic()

        withAnimation(.easeInOut(duration: 0.7)) {
            screen = .result
        }
    }

    func returnHome() {
        currentReading = nil

        withAnimation(.easeInOut(duration: 0.6)) {
            screen = .home
        }
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
        currentReading = MoReading(
            diceValues: [2, 1],
            syllables: ["RA", "DHI"],
            key: "RA_DHI",
            entry: Self.previewEntry
        )
        screen = .result
    }
}
