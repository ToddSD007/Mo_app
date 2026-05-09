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
    var isBookmarked: Bool

    private enum CodingKeys: String, CodingKey {
        case id
        case savedAt
        case question
        case primaryCast
        case secondaryCast
        case firmness
        case firmnessSource
        case entry
        case isBookmarked
    }

    init(
        id: UUID = UUID(),
        savedAt: Date = Date(),
        question: String? = nil,
        primaryCast: MoCastPair,
        secondaryCast: MoCastPair?,
        firmness: MoFirmness?,
        firmnessSource: MoFirmnessSource?,
        entry: MoEntry,
        isBookmarked: Bool = false
    ) {
        self.id = id
        self.savedAt = savedAt
        self.question = question
        self.primaryCast = primaryCast
        self.secondaryCast = secondaryCast
        self.firmness = firmness
        self.firmnessSource = firmnessSource
        self.entry = entry
        self.isBookmarked = isBookmarked
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(UUID.self, forKey: .id)
        savedAt = try container.decode(Date.self, forKey: .savedAt)
        question = try container.decodeIfPresent(String.self, forKey: .question)
        primaryCast = try container.decode(MoCastPair.self, forKey: .primaryCast)
        secondaryCast = try container.decodeIfPresent(MoCastPair.self, forKey: .secondaryCast)
        firmness = try container.decodeIfPresent(MoFirmness.self, forKey: .firmness)
        firmnessSource = try container.decodeIfPresent(MoFirmnessSource.self, forKey: .firmnessSource)
        entry = try container.decode(MoEntry.self, forKey: .entry)
        isBookmarked = try container.decodeIfPresent(Bool.self, forKey: .isBookmarked) ?? false
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
