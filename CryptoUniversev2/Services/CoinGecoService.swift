import Combine
import Foundation

func convertSymbolsToIDs(symbols: [String], completion: @escaping ([String: String]?, Error?) -> Void) {
    let lowercaseSymbols = symbols.map { $0.lowercased() }

    var ids: [String: String] = [:]

    let task = URLSession.shared.dataTask(with: URL(string: "https://api.coingecko.com/api/v3/coins/list")!) { data, _, error in
        if let error {
            print("fetchError")
            completion(nil, error)
            return
        }

        guard let data else {
            print("fetchError")
            completion(nil, NSError(domain: "convertSymbolsToIDs", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty response"]))
            return
        }

        do {
            let coins = try JSONDecoder().decode([[String: String]].self, from: data)

            for coin in coins {
                if let symbol = coin["symbol"]?.lowercased(),
                   let id = coin["id"],
                   lowercaseSymbols.contains(symbol)
                {
                    let uppercaseSymbol = symbol.uppercased()
                    if ids[uppercaseSymbol] == nil {
                        ids[uppercaseSymbol] = id
                    }
                }
            }
            print(ids)
            completion(ids, nil)
        } catch {
            print("fetchError")
            completion(nil, error)
        }
    }
    task.resume()
}

public func fetchExchangeRates(ids: [String]) -> AnyPublisher<[String: Double], Error> {
    let idString = ids.joined(separator: "%2C")
    let url = URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=\(idString)&vs_currencies=usd")!

    return URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: [String: Double].self, decoder: JSONDecoder())
        .eraseToAnyPublisher()
}

public func calculateTotalValueInUSD(exchange: String, completion: @escaping (Double?) -> Void) {
    let cryptoAmounts = UserDefaults.standard.dictionary(forKey: exchange) as? [String: Double]
    print(cryptoAmounts!)
    let symbols = Array(cryptoAmounts!.keys)

    convertSymbolsToIDs(symbols: symbols) { ids, error in
        if let error {
            print("coinGeko - Error making request: \(error.localizedDescription)")
            completion(nil)
        } else if let ids {
            let idList = symbols.compactMap { ids[$0] }

            URLSession.shared.dataTask(with: URL(string: "https://api.coingecko.com/api/v3/simple/price?ids=\(idList.joined(separator: ","))&vs_currencies=usd")!) { data, _, error in
                if let error {
                    print("coinGeko - Error making request: \(error.localizedDescription)")
                    completion(nil)
                    return
                }

                guard let data else {
                    print("coinGeko - Empty response")
                    completion(nil)
                    return
                }

                do {
                    let rates = try JSONDecoder().decode([String: [String: Double]].self, from: data)
                    var totalValue = 0.0
                    var newExchangeData: [String: [Double]] = [:]
                    var prices: [String: Double] = [:]
                    for (symbol, amount) in cryptoAmounts! {
                        let id = ids[symbol] ?? ""
                        let rate = rates[id]?["usd"] ?? 0.0
                        let usdValue = amount * rate
                        prices[symbol] = rate
                        newExchangeData[symbol] = [amount, usdValue]
                        totalValue += usdValue
                    }
                    print(newExchangeData)
                    print(totalValue)
                    saveDataToUserDefaults(key: "CurrentPrices", data: prices)
                    saveDataToUserDefaults(key: exchange, data: newExchangeData)
                    completion(totalValue)
                } catch {
                    print("coinGeko - Error parsing response: \(error.localizedDescription)")
                    completion(nil)
                }
            }.resume()
        }
    }
}

