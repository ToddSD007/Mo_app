import Foundation

struct BookmarkStore {
    private let fileURL: URL
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(fileURL: URL) {
        self.fileURL = fileURL

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        self.encoder = encoder
        self.decoder = JSONDecoder()
    }

    static func live() throws -> BookmarkStore {
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

        return BookmarkStore(fileURL: supportDirectory.appendingPathComponent("bookmarked-entry-keys.json"))
    }

    static func preview() -> BookmarkStore {
        BookmarkStore(fileURL: FileManager.default.temporaryDirectory.appendingPathComponent("mo-preview-bookmarked-entry-keys.json"))
    }

    func loadEntryKeys() throws -> Set<String> {
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            return []
        }

        let data = try Data(contentsOf: fileURL)
        return Set(try decoder.decode([String].self, from: data))
    }

    func saveEntryKeys(_ keys: Set<String>) throws {
        let data = try encoder.encode(keys.sorted())
        try data.write(to: fileURL, options: [.atomic])
    }
}
