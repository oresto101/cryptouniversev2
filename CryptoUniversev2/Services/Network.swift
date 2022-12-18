import Foundation


class Network: ObservableObject {
    @Published var infoBoxes: [InfoBox] = []
    
    @Published var cryptoInfo: [String: [CryptoInfo]] = [:]
    
    @Published var responseCode: Int = 401
    static let shared = Network()
    
    var loginService = LoginService.shared
    
    func callToGetInfoBoxes() {
        let json: [String: Any] = ["action": "infoBoxes"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        guard let url = URL(string: "hz") else { fatalError("Missing URL") }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = jsonData
        urlRequest.addValue(loginService.token, forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedInfoBoxes = try JSONDecoder().decode([InfoBox].self, from: data)
                        self.infoBoxes = decodedInfoBoxes
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
            self.responseCode = response.statusCode
        }

        dataTask.resume()
    }
    
    func callToGetCryptoInfo() {
        guard let url = URL(string: "hz") else { fatalError("Missing URL") }
        let json: [String: Any] = ["action": "cryptoInfo"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(loginService.token, forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonData
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let decodedCryptoInfo = try JSONDecoder().decode([String: [CryptoInfo]].self, from: data)
                        self.cryptoInfo = decodedCryptoInfo
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
                
            }
            self.responseCode = response.statusCode
            
        }
        dataTask.resume()
    }
    
    func getInfoBoxes() -> [InfoBox]{
        
        return self.infoBoxes
//        return [InfoBox(name: "All", totalBalance: 1000, dailyProfitLoss: 100,netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100), InfoBox(name: "Binance", totalBalance: 1000, dailyProfitLoss: 100, netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100), InfoBox(name: "OKX", totalBalance: 1000, dailyProfitLoss: 100, netProfitLoss: 100, dailyProfitLossPercentage: 100, netProfitLossPercentage: 100)]
    }
    
    func getCryptoInfo() -> [String: [CryptoInfo]]{
        return self.cryptoInfo
//        return ["All": [CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100),
//                        CryptoInfo(name: "Binance Coin", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100)],
//                "OKX": [CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100),
//                                CryptoInfo(name: "Binance Coin", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100)],
//                "Binance": [CryptoInfo(name: "Ethereum", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100),
//                                CryptoInfo(name: "Binance Coin", balance:10000.0, amount:1000.0, price: 1000.0, dailyProfitLoss: -100)]]
    }
    
    func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        return self.getCryptoInfo()[exchange]!
    }
}
