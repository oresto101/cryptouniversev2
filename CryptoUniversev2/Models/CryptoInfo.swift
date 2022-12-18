
import Foundation

struct CryptoInfo: Decodable, Hashable {
    var name: String
    var balance: Double
    var amount: Double
    var price: Double
    var dailyProfitLoss: Double
}
