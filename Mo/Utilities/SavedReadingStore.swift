import Foundation

struct SavedReadingStore {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileURL: URL) {
        self.fileURL = fileURL

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    static func live() throws -> SavedReadingStore {
        let supportDirectory = try FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent("Mo", isDirectory: true)

        try FileManager.default.createDirectory(
            at: supportDirectory,
            withIntermediateDirectories: true
        )

        return SavedReadingStore(fileURL: supportDirectory.appendingPathComponent("saved-readings.json"))
    }

    static func preview() -> SavedReadingStore {
        SavedReadingStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("mo-preview-saved-readings.json"))
    }

    func loadReadings() throws -> [SavedReading] {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        return try decoder.decode([SavedReading].self, from: data)
            .sorted { $0.savedAt > $1.savedAt }
    }

    func saveReadings(_ readings: [SavedReading]) throws {
        let data = try encoder.encode(readings.sorted { $0.savedAt > $1.savedAt })
        try data.write(to: fileURL, options: [.atomic])
    }
}
