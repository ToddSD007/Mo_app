import Foundation

enum MoDataError: LocalizedError {
    case missingResource
    case invalidEntryCount(Int)
    case duplicateKey(String)

    var errorDescription: String? {
        switch self {
        case .missingResource:
            return "The bundled Mo entries resource could not be found."
        case .invalidEntryCount(let count):
            return "Expected 36 Mo entries but found \(count)."
        case .duplicateKey(let key):
            return "Duplicate Mo entry key found: \(key)."
        }
    }
}

enum MoEntryLoader {
    static func loadEntries(from bundle: Bundle = .main) throws -> [MoEntry] {
        guard let url = bundle.url(forResource: "mo_entries", withExtension: "json") else {
            throw MoDataError.missingResource
        }

        let data = try Data(contentsOf: url)
        let entries = try JSONDecoder().decode([MoEntry].self, from: data)

        guard entries.count == 36 else {
            throw MoDataError.invalidEntryCount(entries.count)
        }

        return entries
    }
}
