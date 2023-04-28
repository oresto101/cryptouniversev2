//
//  CryptoCompareService.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 21/04/2023.
//

import Foundation
import SwiftyJSON

struct CryptoData: Codable {
    let raw: [String: [String: [String: Double]]]
    let display: [String: [String: [String: String]]]
}


public func storeChangesForCryptoInUsd() {
    var cryptos: Set<String> = []
    exchanges.forEach {
        exchange in
        if let cryptosForCryptoExchange = UserDefaults.standard.dictionary(forKey: "\(exchange)Data") {
            cryptos.formUnion(cryptosForCryptoExchange.keys)
        }
    }
    let url = URL(string: "https://min-api.cryptocompare.com/data/pricemultifull?fsyms=\(cryptos.joined(separator: ","))&tsyms=usd")!
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("8add797c9e72bef06bde41650b18ece2cb3a547c34f44ba6b32775ee769fac9a", forHTTPHeaderField: "Apikey")
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
            cryptos.forEach{
                crypto in
                priceChanges[crypto] = json!["RAW"][crypto]["USD"]["CHANGEPCT24HOUR"].double
            }
            print(priceChanges)
            saveDataToUserDefaults(key: "PriceChanges", data: priceChanges)
        } catch {
            print("cryptocompare - Error parsing response: \(error.localizedDescription)")
        }
    }.resume()
}

