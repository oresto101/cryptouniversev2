
import Foundation

struct CryptoInfo: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var balance: Double
    var amount: Double
    var totalValue: Double
    var dailyProfitLoss: Double
}
