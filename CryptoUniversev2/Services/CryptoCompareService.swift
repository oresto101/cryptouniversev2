//
//  CryptoCompareService.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 21/04/2023.
//

import Foundation
import SwiftyJSON

public func storeChangesForCryptoInUsd() {
    print("WTF")
    var cryptos: Set<String> = []
    exchanges.forEach {
        exchange in
        if let cryptosForCryptoExchange = UserDefaults.standard.dictionary(forKey: "\(exchange)Data") {
            cryptos.formUnion(cryptosForCryptoExchange.keys)
        }
    }
    let url = URL(string: "https://pro-api.coinmarketcap.com/v2/cryptocurrency/quotes/latest?symbol=\(cryptos.joined(separator: ","))")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("f1c18a18-2be4-455f-8d55-8a69e080aeaa", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    dispatchGroup.enter()
    URLSession.shared.dataTask(with: request) { data, _, error in
        if let error {
            print("cyptocompare - Error making request: \(error.localizedDescription)")
            return
        }
        guard let data else {
            print("cyptocompare - Empty response")
            return
        }
        do {
            let json = try? JSON(data: data)
            var priceChanges: [String: Double] = [:]
            var prices: [String: Double] = [:]
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let data = json["data"] as? [String: Any]{
                for (key, value) in data {
                                if let currencyArray = value as? [[String: Any]],
                                   let firstCurrency = currencyArray.first,
                                   let quote = firstCurrency["quote"] as? [String: Any],
                                   let usd = quote["USD"] as? [String: Any],
                                   let price = usd["price"] as? Double, let priceChange = usd["percent_change_24h"] as? Double {
                                    prices[key] = price
                                    priceChanges[key] = priceChange
                                }
                            }
            }
            print(priceChanges)
            print(prices)
            saveDataToUserDefaults(key: "PriceChanges", data: priceChanges)
            saveDataToUserDefaults(key: "Prices", data: prices)
            dispatchGroup.leave()
            print("Prices and price changes saved")

        } catch {
            print("cryptocompare - Error parsing response: \(error.localizedDescription)")
        }
    }.resume()
}
