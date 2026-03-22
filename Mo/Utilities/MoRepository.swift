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

    func reading(for diceValues: [Int]) -> MoReading? {
        let syllables = diceValues.map(syllable(for:))
        let key = syllables.joined(separator: "_")

        guard let entry = entriesByKey[key] else {
            return nil
        }

        return MoReading(diceValues: diceValues, syllables: syllables, key: key, entry: entry)
    }
}
