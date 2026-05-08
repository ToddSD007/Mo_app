import Foundation

struct MoRepository {
    private static let syllableMap: [Int: String] = [
        1: "DHI",
        2: "RA",
        3: "PA",
        4: "NA",
        5: "TSA",
        6: "AH"
    ]

    private let entriesByKey: [String: MoEntry]

    init(entries: [MoEntry]) throws {
        var indexedEntries: [String: MoEntry] = [:]

        for entry in entries {
            if indexedEntries[entry.key] != nil {
                throw MoDataError.duplicateKey(entry.key)
            }

            indexedEntries[entry.key] = entry
        }

        self.entriesByKey = indexedEntries
    }

    func syllable(for diceValue: Int) -> String {
        Self.syllableMap[diceValue, default: "DHI"]
    }

    func castPair(for diceValues: [Int]) -> MoCastPair {
        let syllables = diceValues.map(syllable(for:))
        let key = syllables.joined(separator: "_")

        return MoCastPair(diceValues: diceValues, syllables: syllables, key: key)
    }

    func entry(for key: String) -> MoEntry? {
        entriesByKey[key]
    }

    func reading(
        primaryCast: MoCastPair,
        secondaryCast: MoCastPair?,
        firmness: MoFirmness?,
        firmnessSource: MoFirmnessSource?
    ) -> MoReading? {
        guard let entry = entry(for: primaryCast.key) else {
            return nil
        }

        return MoReading(
            primaryCast: primaryCast,
            secondaryCast: secondaryCast,
            firmness: firmness,
            firmnessSource: firmnessSource,
            entry: entry
        )
    }
}
