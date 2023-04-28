import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public func parseCredentials() {
    let binanceAPI = UserDefaults.standard.string(forKey: "BinanceAPI")
    let binancePassphrase = UserDefaults.standard.string(forKey: "BinanceSecret")
    let okxAPI = UserDefaults.standard.string(forKey: "OKXAPI")
    let okxSecret = UserDefaults.standard.string(forKey: "OKXSecret")
    let okxPassphrase = UserDefaults.standard.string(forKey: "OKXPassphrase")
    let whiteBitAPI = UserDefaults.standard.string(forKey: "WhiteBitAPI")
    let whiteBitSecret = UserDefaults.standard.string(forKey: "WhiteBitSecret")
    let geminiAPI = UserDefaults.standard.string(forKey: "GeminiAPI")
    let geminiSecret = UserDefaults.standard.string(forKey: "GeminiSecret")
    let krakenAPI = UserDefaults.standard.string(forKey: "KrakenAPI")
    let krakenSecret = UserDefaults.standard.string(forKey: "KrakenSecret")

    if binanceAPI != nil, binancePassphrase != nil {
        parseBinance(apiKey: binanceAPI!, secretKey: binancePassphrase!, newData: false) {
            isValid in
            if isValid {
                print("Binance Data Loaded")
            } else {
                UserDefaults.standard.removeObject(forKey: "BinanceAPI")
                UserDefaults.standard.removeObject(forKey: "BinanceSecret")
                UserDefaults.standard.removeObject(forKey: "BinanceData")
                UserDefaults.standard.removeObject(forKey: "BinanceHistoricData")
            }
        }
    }
    if okxAPI != nil, okxSecret != nil, okxPassphrase != nil {
        parseOKX(apiKey: okxAPI!, secretKey: okxSecret!, passphrase: okxPassphrase!, newData: false) {
            isValid in
            if isValid {
                print("OKX Data Loaded")
            } else {
                UserDefaults.standard.removeObject(forKey: "OKXAPI")
                UserDefaults.standard.removeObject(forKey: "OKXSecret")
                UserDefaults.standard.removeObject(forKey: "OKXPassphrase")
                UserDefaults.standard.removeObject(forKey: "OKXData")
                UserDefaults.standard.removeObject(forKey: "OKXHistoricData")
            }
        }
    }
    if whiteBitAPI != nil, whiteBitSecret != nil {
        parseWhiteBit(apiKey: whiteBitAPI!, secretKey: whiteBitSecret!, newData: false) { isValid in
            if isValid {
                print("WhiteBit Data Loaded")
            } else {
                UserDefaults.standard.removeObject(forKey: "WhiteBitAPI")
                UserDefaults.standard.removeObject(forKey: "WhiteBitSecret")
                UserDefaults.standard.removeObject(forKey: "WhiteBitData")
                UserDefaults.standard.removeObject(forKey: "WhiteBitHistoricData")
            }
        }
    }
    if geminiAPI != nil, geminiSecret != nil {
        parseGemini(apiKey: geminiAPI!, secretKey: geminiSecret!, newData: false) { isValid in
            if isValid {
                print("Gemini Data Loaded")
            } else {
                UserDefaults.standard.removeObject(forKey: "GeminiAPI")
                UserDefaults.standard.removeObject(forKey: "GeminiSecret")
                UserDefaults.standard.removeObject(forKey: "GeminiData")
                UserDefaults.standard.removeObject(forKey: "GeminiHistoricData")
            }
        }
    }
    if krakenAPI != nil, krakenSecret != nil {
        parseKraken(apiKey: krakenAPI!, secretKey: krakenSecret!, newData: false) { isValid in
            if isValid {
                print("Kraken Data Loaded")
            } else {
                UserDefaults.standard.removeObject(forKey: "KrakenAPI")
                UserDefaults.standard.removeObject(forKey: "KrakenSecret")
                UserDefaults.standard.removeObject(forKey: "KrakenData")
                UserDefaults.standard.removeObject(forKey: "KrakenHistoricData")
            }
        }
    }
    storeChangesForCryptoInUsd()
}

public func parseExchanges(username _: String, password _: String) {}
