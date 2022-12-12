
import Foundation

struct InfoBox: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var totalBalance: Double
    var dailyProfitLoss: Double
    var netProfitLoss: Double
}
