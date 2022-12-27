//
//  CryptoExchange.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 27/12/2022.
//

import Foundation


private var requirePassphrase = [Exchange.okx]
private var exchangeToIdDict: [Exchange: String] = [Exchange.binance: "1", Exchange.okx: "2", Exchange.whitebit: "10", Exchange.manual: "6", Exchange.kraken: "8", Exchange.gemini: "9"]
private var exchangeToNameDict: [Exchange: String] = [Exchange.binance: "Binance", Exchange.okx: "OKX", Exchange.whitebit: "WhiteBit", Exchange.manual: "Manual", Exchange.kraken: "Kraken", Exchange.gemini: "Gemini"]
private var nameToExchangeDict: [String: Exchange] = ["Binance": Exchange.binance, "OKX": Exchange.okx, "WhiteBit": Exchange.whitebit, "Manual": Exchange.manual, "Kraken": Exchange.kraken, "Gemini":  Exchange.gemini]
enum Exchange: String, CaseIterable, Identifiable, Equatable {
    case binance, okx, whitebit, manual, kraken, gemini
    
    var name: String { return exchangeToNameDict[self]!}
    var id: String { return exchangeToIdDict[self]! }
    var requiresPassphrase: Bool {
        return requirePassphrase.contains(self)
    }
}

func getExchangeByName(name: String) -> Exchange {
    return nameToExchangeDict[name]!
}
