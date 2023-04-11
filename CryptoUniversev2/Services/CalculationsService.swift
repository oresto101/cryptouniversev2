import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

class CalculationsService: ObservableObject {
    static let shared = CalculationsService()

    func collectCredentials() -> [String: [String: String]] {
        let binanceAPI = UserDefaults.standard.string(forKey: "BinanceAPI")
        let binancePassphrase = UserDefaults.standard.string(forKey: "BinancePassphrase")
        let okxAPI = UserDefaults.standard.string(forKey: "OKXAPI")
        let okxPassphrase = UserDefaults.standard.string(forKey: "OKXPassphrase")

        var resultDict: [String: [String: String]] = [:]

        if binanceAPI != nil && binancePassphrase != nil {
            var binanceDict: [String: String] = [:]
            if let api = binanceAPI {
                binanceDict["BinanceAPI"] = api
            }
            if let passphrase = binancePassphrase {
                binanceDict["BinancePassphrase"] = passphrase
            }
            resultDict["Binance"] = binanceDict
        }

        if okxAPI != nil && okxPassphrase != nil {
            var okxDict: [String: String] = [:]
            if let api = okxAPI {
                okxDict["OKXAPI"] = api
            }
            if let passphrase = okxPassphrase {
                okxDict["OKXPassphrase"] = passphrase
            }
            resultDict["OKX"] = okxDict
        }

        return resultDict
    }

    func parseExchanges(username _: String, password _: String) {}
}
