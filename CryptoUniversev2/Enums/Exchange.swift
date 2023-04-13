import Foundation

private var requirePassphrase = [Exchange.okx]
private var exchangeToIdDict: [Exchange: String] = [
    Exchange.binance: "1",
    Exchange.okx: "2",
    Exchange.whitebit: "3",
    Exchange.gemini: "4",
    Exchange.kraken: "5",
]
private var exchangeToNameDict: [Exchange: String] = [
    Exchange.binance: "Binance",
    Exchange.okx: "OKX",
    Exchange.whitebit: "WhiteBit",
    Exchange.gemini: "Gemini",
    Exchange.kraken: "Kraken",
]
private var nameToExchangeDict: [String: Exchange] = [
    "Binance": Exchange.binance,
    "OKX": Exchange.okx,
    "WhiteBit": Exchange.whitebit,
    "Gemini": Exchange.gemini,
    "Kraken": Exchange.kraken,
]
enum Exchange: String, CaseIterable, Identifiable, Equatable {
    case binance, okx, whitebit, gemini, kraken

    var name: String { exchangeToNameDict[self]! }
    var id: String { exchangeToIdDict[self]! }
    var requiresPassphrase: Bool {
        requirePassphrase.contains(self)
    }
}

func getExchangeByName(name: String) -> Exchange {
    nameToExchangeDict[name]!
}
