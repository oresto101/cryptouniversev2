import Foundation


class Network: ObservableObject {
    @Published var infoBoxes: [InfoBox] = []
    
    @Published var cryptoInfo: [String: [CryptoInfo]] = [:]
    
    static let shared = Network()
    
    func callToGetInfoBoxes() {
        guard let url = URL(string: "hz") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

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
        }

        dataTask.resume()
    }
    
    func callToGetCryptoInfo() {
        guard let url = URL(string: "hz") else { fatalError("Missing URL") }

        let urlRequest = URLRequest(url: url)

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
        }

        dataTask.resume()
    }
    
    func getInfoBoxes() -> [InfoBox]{
        
        //todo return infoBoxes
        return [InfoBox(id: 1, name: "All", totalBalance: 1000, dailyProfitLoss: 100, netProfitLoss: 100), InfoBox(id: 2, name: "Binance", totalBalance: 1000, dailyProfitLoss: 100, netProfitLoss: 100)]
    }
    
    func getCryptoInfo() -> [String: [CryptoInfo]]{
        return ["All": [CryptoInfo(id: 1, name: "Ethereum", balance:10000.0, amount:1000.0, totalValue: 1000.0, dailyProfitLoss: -100),
                        CryptoInfo(id: 2, name: "Binance Coin", balance:10000.0, amount:1000.0, totalValue: 1000.0, dailyProfitLoss: -100)],
                "Binance": [CryptoInfo(id: 1, name: "Ethereum", balance:10000.0, amount:1000.0, totalValue: 1000.0, dailyProfitLoss: -100),
                                CryptoInfo(id: 2, name: "Binance Coin", balance:10000.0, amount:1000.0, totalValue: 1000.0, dailyProfitLoss: -100)]]
    }
    
    func getCryptoInfoForExchange(exchange: String) -> [CryptoInfo] {
        return self.getCryptoInfo()[exchange]!
    }
}