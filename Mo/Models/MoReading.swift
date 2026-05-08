import Foundation

struct MoCastPair: Equatable, Codable {
    let diceValues: [Int]
    let syllables: [String]
    let key: String

    static let placeholder = MoCastPair(
        diceValues: [1, 1],
        syllables: ["DHI", "DHI"],
        key: "DHI_DHI"
    )

    var displaySyllables: String {
        syllables.joined(separator: " • ")
    }

    var reversedKey: String {
        syllables.reversed().joined(separator: "_")
    }
}

enum MoFirmness: String, Codable {
    case veryFirm
    case weak
    case standard

    var title: String {
        switch self {
        case .veryFirm:
            return "The indication is strong."
        case .weak:
            return "The matter is not yet settled."
        case .standard:
            return "This answer stands as given."
        }
    }

    var description: String {
        switch self {
        case .veryFirm:
            return "The answer is especially stable, clear, and worthy of trust. Receive this answer with confidence and let it guide your next steps."
        case .weak:
            return "Circumstances remain unsettled and conditional. The answer should be held lightly. Allow it to inform your reflection, but do not take it as final."
        case .standard:
            return "Accept it with openness and contemplate its meaning carefully. Let understanding unfold with time."
        }
    }
}

enum MoFirmnessEvaluator {
    static func evaluate(primary: MoCastPair, secondary: MoCastPair) -> MoFirmness {
        if primary.key == secondary.key {
            return .veryFirm
        }

        if primary.reversedKey == secondary.key {
            return .weak
        }

        return .standard
    }
}

enum MoFirmnessSource: String, Codable {
    case ritual
    case manual
}

struct MoReading {
    let primaryCast: MoCastPair
    let secondaryCast: MoCastPair?
    let firmness: MoFirmness?
    let firmnessSource: MoFirmnessSource?
    let entry: MoEntry

    var diceValues: [Int] {
        primaryCast.diceValues
    }

    var syllables: [String] {
        primaryCast.syllables
    }

    var key: String {
        primaryCast.key
    }
}
