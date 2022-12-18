import Foundation


class Network: ObservableObject {
    var infoBoxes: [InfoBox] = []
    
    var cryptoInfo: [String: [CryptoInfo]] = [:]
    
    var responseCode: Int = 401
    static let shared = Network()
    
    var str = "[{\"name\":\"Overall\",\"totalBalance\":533.25,\"dailyProfitLoss\":0,\"netProfitLoss\":-0.826794800807365,\"dailyProfitLossPercentage\":0,\"netProfitLossPercentage\":0},{\"name\":\"Kraken\",\"totalBalance\":14.15,\"dailyProfitLoss\":0,\"netProfitLoss\":0.030000000000001137,\"dailyProfitLossPercentage\":0,\"netProfitLossPercentage\":0},{\"name\":\"Binance\",\"totalBalance\":473.08,\"dailyProfitLoss\":0,\"netProfitLoss\":-1.1400000000000432,\"dailyProfitLossPercentage\":0,\"netProfitLossPercentage\":0},{\"name\":\"WhiteBit\",\"totalBalance\":13.64,\"dailyProfitLoss\":0,\"netProfitLoss\":0.02000000000000135,\"dailyProfitLossPercentage\":0,\"netProfitLossPercentage\":0},{\"name\":\"Gemini\",\"totalBalance\":11.78,\"dailyProfitLoss\":0,\"netProfitLoss\":-0.009999999999999787,\"dailyProfitLossPercentage\":0,\"netProfitLossPercentage\":0},{\"name\":\"OKX\",\"totalBalance\":20.28,\"dailyProfitLoss\":0,\"netProfitLoss\":0.2699999999999996,\"dailyProfitLossPercentage\":0,\"netProfitLossPercentage\":0},{\"name\":\"Manual\",\"totalBalance\":0.32,\"dailyProfitLoss\":0,\"netProfitLoss\":0.0032051991926759227,\"dailyProfitLossPercentage\":0,\"netProfitLossPercentage\":0}]"
    
    var loginService = LoginService.shared
    
    func parseInfoBox(json: Data) -> [InfoBox] {
          let decoder = JSONDecoder()
          do {
            let box = try decoder.decode([InfoBox].self, from: json)
            return box
          } catch {
            print("Error decoding JSON: \(error)")
            return []
          }
        }
    
    func parseCryptoInfo(json: Data) -> [String: [CryptoInfo]] {
          let decoder = JSONDecoder()
          do {
            let info = try decoder.decode([String: [CryptoInfo]].self, from: json)
            return info
          } catch {
            print("Error decoding JSON: \(error)")
              return [:]
          }
        }
    
    func callToGetInfoBoxes() {
        let parameters = "action=infoBoxes"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/request_data/")!,timeoutInterval: Double.infinity)
        request.addValue("Token 789c2fc55deac8da70dba632eb768fa08aed1a4d", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Request error: ", error)
                return
            }

            guard let response = response as? HTTPURLResponse else { return }

            if response.statusCode == 200 {
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                let boxes = self.parseInfoBox(json: data!)
                self.infoBoxes = boxes

            }
            self.responseCode = response.statusCode
        }
        
        dataTask.resume()
    }
    
    func callToGetCryptoInfo() {

        let parameters = "action=cryptoInfo"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/request_data/")!,timeoutInterval: Double.infinity)
        request.addValue("Token 789c2fc55deac8da70dba632eb768fa08aed1a4d", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                if let error = error {
                    print("Request error: ", error)
                    return
                }
                let cryptoBoxes = self.parseCryptoInfo(json: data!)
                self.cryptoInfo = cryptoBoxes
                
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
