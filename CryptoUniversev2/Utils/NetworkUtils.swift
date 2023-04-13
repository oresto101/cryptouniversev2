import Foundation

public func saveDataToUserDefaults(key: String, data: [String: Double]) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
}

public func saveDataToUserDefaults(key: String, data: [String: [Double]]) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
}

public func saveDataToUserDefaults(key: String, data: String) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
}

public func saveDataToUserDefaults(key: String, data: Double) {
    let userDefaults = UserDefaults.standard
    userDefaults.set(data, forKey: key)
}

// public func calculateTotalMoneyInUSD(exchange: String, completion: @escaping (Double) -> Void) {
//    let coins = UserDefaults.standard.dictionary(forKey: exchange) as? [String: Double]
//    let dispatchGroup = DispatchGroup()
//    var totalMoney = 0.0
//    var newExchangeData: [String: [Double]] = [:]
//
//    for (coin, amount) in coins! {
//        dispatchGroup.enter()
//        convertCoinToUSD(name: coin, amount: amount) { usdValue in
//            if usdValue >= 0 {
//                totalMoney += usdValue
//                newExchangeData[coin] = [amount, usdValue]
//                dispatchGroup.leave()
//            } else {
//                newExchangeData[coin] = [amount, usdValue]
//                dispatchGroup.leave()
//            }
//        }
//    }
//
//    dispatchGroup.notify(queue: .main) {
//        saveDataToUserDefaults(key: exchange, data: newExchangeData)
//        completion(totalMoney)
//    }
// }
