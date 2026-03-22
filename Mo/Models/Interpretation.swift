import Foundation

struct Interpretation: Decodable {
    let general: String
    let favorableFor: [String]
    let caution: String
}
