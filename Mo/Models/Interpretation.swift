import Foundation

struct Interpretation: Decodable {
    let meaning: String
    let meaningShort: String
    let spiritualPractice: String
    let favorableFor: [String]
    let caution: String
}
