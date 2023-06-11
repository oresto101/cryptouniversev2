//
//  CryptoInfoParser.swift
//  CryptoUniversev2
//
//  Created by Orest Haman on 11/06/2023.
//

import Foundation

func retrieveDataAndParseCryptoInfo() -> ([InfoBox], [String: [CryptoInfo]], Bool){
    let cryptoPrices = UserDefaults.standard.dictionary(forKey: "Prices")! as! [String: Double]
    let priceChanges = UserDefaults.standard.dictionary(forKey: "PriceChanges")! as! [String: Double]
    let exchangesToBeParsed = getExchangesToBeParsed()
    return parseCryptoInfo(cryptoPrices: cryptoPrices, priceChanges: priceChanges, exchangesToBeParsed: exchangesToBeParsed)
}

func parseCryptoInfo(cryptoPrices: [String: Double], priceChanges: [String: Double], exchangesToBeParsed: [String: [String: Double]]) -> ([InfoBox], [String: [CryptoInfo]], Bool){
    var infoBoxes: [InfoBox] = []
    var cryptoInfo: [String: [CryptoInfo]] = [:]
    var exchangeTotals: [String: Double] = [:]
    var exchangeDailyPL: [String: Double] = [:]
    var noData = false
    (cryptoInfo, exchangeDailyPL, exchangeTotals) = parseCryptoInfoByExchange(exchangesToBeParsed: exchangesToBeParsed, cryptoPrices: cryptoPrices, priceChanges: priceChanges)
    for (exchangeName, cryptoInfos) in cryptoInfo {
        cryptoInfo[exchangeName] = cryptoInfos.sorted { $0.balance > $1.balance }
    }
    infoBoxes = exchangeTotals.compactMap {
        name, value in
        storeHistoricDataIfNotStoredYet(name: name, totalValue: value)
        return getInfoBox(name: name, totalValue: value, exchangeDailyPL: exchangeDailyPL)
    }
    print(infoBoxes)
    infoBoxes = infoBoxes.sorted { $0.totalBalance > $1.totalBalance }
    if infoBoxes.count > 0 {
        infoBoxes.insert(
            calculateOveralls(infoBoxes: infoBoxes),
            at: 0
        )
    } else {
        noData = true
    }
    return (infoBoxes, cryptoInfo, noData)
}

func storeHistoricDataIfNotStoredYet(name: String, totalValue: Double) {
    if UserDefaults.standard.value(forKey: "\(name)HistoricData") == nil {
        saveDataToUserDefaults(key: "\(name)HistoricData", data: totalValue)
    }
}
func getInfoBox(name: String, totalValue: Double, exchangeDailyPL: [String: Double]) -> InfoBox {
    let netprofitLoss = Double(UserDefaults.standard.integer(forKey: "\(name)HistoricData")) - totalValue
    let netProfitLossPercentage = (Double(UserDefaults.standard.integer(forKey: "\(name)HistoricData")) / totalValue) - 1
    let dailyProfitLossPercentage = ((totalValue - exchangeDailyPL[name]!) / totalValue) - 1
    return InfoBox(
        name: name,
        totalBalance: totalValue,
        dailyProfitLoss: exchangeDailyPL[name]!,
        netProfitLoss: netprofitLoss,
        dailyProfitLossPercentage: dailyProfitLossPercentage,
        netProfitLossPercentage: netProfitLossPercentage
    )
}


func calculateOveralls(infoBoxes: [InfoBox]) -> InfoBox {
    var overallProfitLoss = 0.0
    var overallDailyProfitLoss = 0.0
    var overallSum = 0.0
    infoBoxes.forEach {
        infobox in
        overallProfitLoss += infobox.netProfitLoss
        overallSum += infobox.totalBalance
        overallDailyProfitLoss += infobox.dailyProfitLoss
    }
    let netProfitLossPercentage = ((overallSum - overallProfitLoss) / overallSum) - 1
    let dailyProfitLossPercentage = ((overallSum - overallDailyProfitLoss) / overallSum) - 1
    return InfoBox(name: "Overall", totalBalance: overallSum, dailyProfitLoss: overallDailyProfitLoss, netProfitLoss: overallProfitLoss, dailyProfitLossPercentage: dailyProfitLossPercentage,
                   netProfitLossPercentage: netProfitLossPercentage)
}

func parseCryptoInfoByExchange(exchangesToBeParsed: [String: [String: Double]], cryptoPrices: [String: Double], priceChanges: [String: Double]) -> ([String: [CryptoInfo]], [String: Double], [String: Double]) {
    var cryptoInfo: [String: [CryptoInfo]] = [:]
    var exchangeDailyPL: [String: Double] = [:]
    var exchangeTotals: [String: Double] = [:]
    var overalls: [String: Double] = [:]
    exchangesToBeParsed.forEach {
        exchangeName, data in
        var totalForExchange = 0.0
        var dailyPLForExchange = 0.0
        cryptoInfo[exchangeName] = data.compactMap { symbol, value in
            let val = value
            let price = val * (cryptoPrices[symbol]!)
            overalls[symbol] = overalls[symbol, default: 0.0] + val
            totalForExchange += price
            if (priceChanges[symbol]!) != 0.0 {
                dailyPLForExchange += price * (priceChanges[symbol]!) / 100
            }
            return CryptoInfo(
                name: symbol,
                balance: roundDoubles(val: price),
                amount: roundDoubles(val: val),
                price: cryptoPrices[symbol]!,
                dailyProfitLoss: priceChanges[symbol]!
            )
        }
        exchangeDailyPL[exchangeName] = dailyPLForExchange
        exchangeTotals[exchangeName] = totalForExchange
    }
    cryptoInfo["Overall"] = overalls.compactMap { symbol, values in
        CryptoInfo(
            name: symbol,
            balance: roundDoubles(val: cryptoPrices[symbol]! * values),
            amount: roundDoubles(val: values),
            price: cryptoPrices[symbol]!,
            dailyProfitLoss: priceChanges[symbol]!
        )
    }
    return (cryptoInfo, exchangeDailyPL, exchangeTotals)
}

func getExchangesToBeParsed() -> [String: [String: Double]] {
    var exchangesToBeParsed: [String: [String: Double]] = [:]
    exchanges.forEach {
        exchangeName in
        if let data = (UserDefaults.standard.dictionary(forKey: "\(exchangeName)Data")) as? [String: Double] {
            exchangesToBeParsed[exchangeName] = data
        }
    }
    return exchangesToBeParsed
}
