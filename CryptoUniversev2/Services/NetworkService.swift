import Foundation

class NetworkService: ObservableObject {
    var infoBoxes: [InfoBox] = []
    
    var cryptoInfo: [String: [CryptoInfo]] = [:]
    
    var responseCode: Int = 401
    static let shared = NetworkService()
    
    var loginService = LoginService.shared
    
    func parseInfoBox(json: Data) -> [InfoBox] {
          let decoder = JSONDecoder()
          do {
            let box = try decoder.decode([InfoBox].self, from: json)
            return box
          } catch {
            return []
          }
        }
    
    func parseCryptoInfo(json: Data) -> [String: [CryptoInfo]] {
          let decoder = JSONDecoder()
          do {
            let info = try decoder.decode([String: [CryptoInfo]].self, from: json)
            return info
          } catch {
              return [:]
          }
        }
    
    func callToGetInfoBoxes() -> [InfoBox]{
        let parameters = "action=infoBoxes"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/request_data/")!,timeoutInterval: Double.infinity)
        print(loginService.token)
        request.addValue(loginService.token, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let dataTask = URLSession.shared
            .dataTask(with: request) { (data, response, error) in
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
        return self.infoBoxes
    }
    
    func callToGetCryptoInfo() -> [String: [CryptoInfo]]{

        let parameters = "action=cryptoInfo"
        let postData =  parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/api/v1/request_data/")!,timeoutInterval: Double.infinity)
        request.addValue(loginService.token, forHTTPHeaderField: "Authorization")
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
        return self.cryptoInfo
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
    
    
}
