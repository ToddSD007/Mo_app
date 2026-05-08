import Foundation

struct MoEntry: Codable, Identifiable {
    let id: Int
    let key: String
    let dice: [Int]
    let syllables: [String]
    let title: String
    let overallTone: String
    let summary: String
    let interpretation: Interpretation
}
