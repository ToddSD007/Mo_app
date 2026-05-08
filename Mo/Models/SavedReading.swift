import Foundation

struct SavedReading: Codable, Identifiable {
    let id: UUID
    let savedAt: Date
    let question: String?
    let primaryCast: MoCastPair
    let secondaryCast: MoCastPair?
    let firmness: MoFirmness?
    let firmnessSource: MoFirmnessSource?
    let entry: MoEntry

    init(
        id: UUID = UUID(),
        savedAt: Date = Date(),
        question: String? = nil,
        primaryCast: MoCastPair,
        secondaryCast: MoCastPair?,
        firmness: MoFirmness?,
        firmnessSource: MoFirmnessSource?,
        entry: MoEntry
    ) {
        self.id = id
        self.savedAt = savedAt
        self.question = question
        self.primaryCast = primaryCast
        self.secondaryCast = secondaryCast
        self.firmness = firmness
        self.firmnessSource = firmnessSource
        self.entry = entry
    }

    init(reading: MoReading, question: String? = nil) {
        self.init(
            question: question?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty,
            primaryCast: reading.primaryCast,
            secondaryCast: reading.secondaryCast,
            firmness: reading.firmness,
            firmnessSource: reading.firmnessSource,
            entry: reading.entry
        )
    }

    var title: String {
        entry.title
    }

    var displaySyllables: String {
        primaryCast.displaySyllables
    }
}

private extension String {
    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}
