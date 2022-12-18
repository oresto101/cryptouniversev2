
import Foundation

struct InfoBox: Decodable, Hashable {
    var name: String
    var totalBalance: Double
    var dailyProfitLoss: Double
    var netProfitLoss: Double
    var dailyProfitLossPercentage: Double
    var netProfitLossPercentage: Double
}
