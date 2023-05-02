import CryptoKit
import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

func parseBinance(apiKey: String, secretKey: String, newData: Bool, completion: @escaping (Bool) -> Void) {
    let baseURL = "https://api.binance.com"
    let endpoint = "/api/v3/account"

    let timeStamp = Int(Date().timeIntervalSince1970 * 1000)
    let queryString = "timestamp=\(timeStamp)"

    let secretKeyData = Data(secretKey.utf8)
    let signature = HMAC<SHA256>.authenticationCode(for: Data(queryString.utf8), using: SymmetricKey(data: secretKeyData)).reduce("") { $0 + String(format: "%02x", $1) }

    let signedURL = "\(baseURL)\(endpoint)?\(queryString)&signature=\(signature)"

    var request = URLRequest(url: URL(string: signedURL)!)
    request.httpMethod = "GET"
    request.addValue(apiKey, forHTTPHeaderField: "X-MBX-APIKEY")

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
            return
        }

        do {
            print(data)
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let balances = json["balances"] as? [[String: Any]]
            {
                var result: [String: Double] = [:]

                for balance in balances {
                    if let asset = balance["asset"] as? String,
                       let freeString = balance["free"] as? String,
                       let free = Double(freeString), free > 0
                    {
                        if asset.starts(with: "LD"){
                            continue
                        }
                        if asset == "BTTC" {
                            result["BTT"] = free
                        } else {
                            result[asset] = free
                        }
                    }
                }
                saveDataToUserDefaults(key: "BinanceAPI", data: apiKey)
                saveDataToUserDefaults(key: "BinanceSecret", data: secretKey)
                saveDataToUserDefaults(key: "BinanceData", data: result)
                calculateTotalValueInUSD(exchange: "BinanceData") { historicData in
                    if newData {
                        saveDataToUserDefaults(key: "BinanceHistoricData", data: historicData ?? 0)
                    }
                }
                storeChangesForCryptoInUsd()
                completion(true)
            } else {
                print("Binance - Error: Unable to parse JSON")
                completion(false)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
            completion(false)
        }
    }

    task.resume()
}

public func parseOKX(apiKey: String, secretKey: String, passphrase: String, newData: Bool, completion: @escaping (Bool) -> Void) {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let timestamp = dateFormatter.string(from: Date())

    let method = "GET"
    let path = "/api/v5/account/balance"
    let message = "\(timestamp)\(method)\(path)"

    guard let secretKeyData = secretKey.data(using: .utf8),
          let messageData = message.data(using: .utf8)
    else {
        print("OKX - Error converting strings to data")
        return
    }

    let signature = HMAC<SHA256>.authenticationCode(for: messageData, using: SymmetricKey(data: secretKeyData))
    let signatureBase64 = Data(signature).base64EncodedString()

    guard let url = URL(string: "https://www.okx.com/api/v5/account/balance") else {
        print("OKX - Error creating URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(apiKey, forHTTPHeaderField: "OK-ACCESS-KEY")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "accept")
    request.addValue(signatureBase64, forHTTPHeaderField: "OK-ACCESS-SIGN")
    request.addValue(passphrase, forHTTPHeaderField: "OK-ACCESS-PASSPHRASE")
    request.addValue(timestamp, forHTTPHeaderField: "OK-ACCESS-TIMESTAMP")

    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        if error != nil {
            print("Request error: ", error as Any)
            completion(false)
            return
        }

        guard let data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let responseData = json["data"] as? [[String: Any]],
              let details = responseData.first?["details"] as? [[String: Any]]
        else {
            print("OKX - Error parsing JSON")
            completion(false)
            return
        }

        var result: [String: Double] = [:]

        for currency in details {
            if let ccy = currency["ccy"] as? String,
               let availBal = currency["availBal"] as? String,
               let availBalDouble = Double(availBal)
            {
                result[ccy] = availBalDouble
            }
        }
        saveDataToUserDefaults(key: "OKXAPI", data: apiKey)
        saveDataToUserDefaults(key: "OKXSecret", data: secretKey)
        saveDataToUserDefaults(key: "OKXPassphrase", data: passphrase)
        saveDataToUserDefaults(key: "OKXData", data: result)
        calculateTotalValueInUSD(exchange: "OKXData") {
            historicData in
            if newData {
                saveDataToUserDefaults(key: "OKXHistoricData", data: historicData!)
            }
        }
        storeChangesForCryptoInUsd()
        completion(true)
    }

    task.resume()
}

// TODO: Fix
func parseWhiteBit(apiKey: String, secretKey: String, newData: Bool, completion: @escaping (Bool) -> Void) {
    func requestWhiteBitBalance(requestPath: String, completion: @escaping ([String: Double]) -> Void) {
        func wb_hmac(key: String, input: String) -> String? {
            guard let keyData = key.data(using: .utf8), let inputData = input.data(using: .utf8) else {
                return nil
            }

            let symmetricKey = SymmetricKey(data: keyData)
            let hmac = HMAC<SHA512>.authenticationCode(for: inputData, using: symmetricKey)

            return hmac.map { String(format: "%02x", $0) }.joined()
        }
        let baseUrl = "https://whitebit.com"
        let nonce = UInt64(Date().timeIntervalSince1970 * 1000)

        let data: [String: Any] = [
            "request": requestPath,
            "nonce": nonce,
        ]

        guard let dataJson = try? JSONSerialization.data(withJSONObject: data, options: []) else {
            print("WhiteBit - Error: Cannot create JSON data")
            return
        }

        let payload = dataJson.base64EncodedString()
        guard let signature = wb_hmac(key: secretKey, input: payload) else {
            print("WhiteBit - Error: Cannot create HMAC signature")
            return
        }

        let headers = [
            "Content-type": "application/json",
            "X-TXC-APIKEY": apiKey,
            "X-TXC-PAYLOAD": payload,
            "X-TXC-SIGNATURE": signature,
        ]

        let completeUrl = baseUrl + requestPath

        var request = URLRequest(url: URL(string: completeUrl)!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = dataJson

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data, error == nil else {
                print("WhiteBit - Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }

            if let content = String(data: data, encoding: .utf8) {
                print("WhiteBit - Content of data: \(content)")
            } else {
                print("WhiteBit - Unable to convert data to a String.")
            }

            guard let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [String: Any]] else {
                print("WhiteBit - Error: Cannot parse JSON response")
                return
            }

            var result: [String: Double] = [:]
            for (ccy, ccyInfo) in jsonResponse {
                if let balance = ccyInfo["main_balance"] as? Double, balance > 0 {
                    result[ccy] = balance
                }
                if let available = ccyInfo["available"] as? Double, available > 0 {
                    result[ccy, default: 0] += available
                }
            }

            completion(result)
        }

        task.resume()
    }

    let mainAccountRequest = "/api/v4/main-account/balance"
    let tradeAccountRequest = "/api/v4/trade-account/balance"

    requestWhiteBitBalance(requestPath: mainAccountRequest) { mainAccountBalances in
        requestWhiteBitBalance(requestPath: tradeAccountRequest) { tradeAccountBalances in
            var finalResult: [String: Double] = mainAccountBalances

            for (ccy, balance) in tradeAccountBalances {
                finalResult[ccy, default: 0] += balance
            }

            if finalResult.isEmpty {
                completion(false)
            } else {
                saveDataToUserDefaults(key: "WhiteBitAPI", data: apiKey)
                saveDataToUserDefaults(key: "WhiteBitSecret", data: secretKey)
                saveDataToUserDefaults(key: "WhiteBitData", data: finalResult)
                if newData {
                    saveDataToUserDefaults(key: "WhiteBitHistoricData", data: finalResult)
                }
                completion(true)
            }
        }
    }
}

public func parseGemini(apiKey: String, secretKey: String, newData: Bool, completion: @escaping (Bool) -> Void) {
    let url = URL(string: "https://api.gemini.com/v1/balances")!
    let payloadNonce = Int(Date().timeIntervalSince1970)
    let payload: [String: Any] = ["request": "/v1/balances", "nonce": payloadNonce]
    let encodedPayload = try! JSONSerialization.data(withJSONObject: payload)
    let b64 = encodedPayload.base64EncodedString()

    let key = SymmetricKey(data: secretKey.data(using: .utf8)!)
    let signature = HMAC<SHA384>.authenticationCode(for: Data(b64.utf8), using: key)
    let signatureHexString = signature.map { String(format: "%02x", $0) }.joined()

    var request = URLRequest(url: url)
    request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
    request.setValue("0", forHTTPHeaderField: "Content-Length")
    request.setValue(apiKey, forHTTPHeaderField: "X-GEMINI-APIKEY")
    request.setValue(b64, forHTTPHeaderField: "X-GEMINI-PAYLOAD")
    request.setValue(signatureHexString, forHTTPHeaderField: "X-GEMINI-SIGNATURE")
    request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
    request.httpMethod = "POST"
    let task = URLSession.shared.dataTask(with: request) { data, _, error in
        if let error {
            print("Gemini - Request error: ", error)
            completion(false)
            return
        }

        guard let data else { return }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                var res: [String: Double] = [:]
                for ccy in json {
                    if let currency = ccy["currency"] as? String, let amountString = ccy["amount"] as? String, let amount = Double(amountString) {
                        res[currency] = amount
                    }
                }
                saveDataToUserDefaults(key: "GeminiAPI", data: apiKey)
                saveDataToUserDefaults(key: "GeminiSecret", data: secretKey)
                saveDataToUserDefaults(key: "GeminiData", data: res)
                calculateTotalValueInUSD(exchange: "GeminiData") {
                    historicData in
                    if newData {
                        saveDataToUserDefaults(key: "GeminiHistoricData", data: historicData!)
                    }
                }
                storeChangesForCryptoInUsd()
                completion(true)
            } else {
                completion(false)
            }
        } catch {
            print("Gemini - JSON parsing error: ", error)
            completion(false)
        }
    }

    task.resume()
}

func parseKraken(apiKey: String, secretKey: String, newData: Bool, completion: @escaping (Bool) -> Void) {
    let url = URL(string: "https://api.kraken.com/0/private/Balance")!
    let urlPath = "/0/private/Balance"
    let payloadNonce = "\(Int(Date().timeIntervalSince1970 * 1000))"

    var data = [String: String]()
    data["nonce"] = payloadNonce

    let postData = data.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
    let encoded = (payloadNonce + postData).data(using: .utf8)!

    let message = urlPath.data(using: .utf8)! + SHA256.hash(data: encoded)
    guard let secretKeyData = Data(base64Encoded: secretKey) else {
        print("Kraken - Error: Unable to decode base64-encoded secret key")
        completion(false)
        return
    }
    let mac = HMAC<SHA512>.authenticationCode(for: message, using: SymmetricKey(data: secretKeyData))
    let signature = Data(mac).base64EncodedString()

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue(apiKey, forHTTPHeaderField: "API-Key")
    request.setValue(signature, forHTTPHeaderField: "API-Sign")
    request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = postData.data(using: .utf8)

    URLSession.shared.dataTask(with: request) { data, _, error in
        guard let data, error == nil else {
            print("Error: \(error?.localizedDescription ?? "Unknown error")")
            completion(false)
            return
        }

        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let result = json["result"] as? [String: String]
            {
                var res = [String: Double]()
                for (ccy, value) in result {
                    if let doubleValue = Double(value) {
                        res[ccy] = doubleValue
                    }
                }
                saveDataToUserDefaults(key: "KrakenAPI", data: apiKey)
                saveDataToUserDefaults(key: "KrakenSecret", data: secretKey)
                saveDataToUserDefaults(key: "KrakenData", data: res)
                calculateTotalValueInUSD(exchange: "KrakenData") { historicData in
                    if newData {
                        saveDataToUserDefaults(key: "KrakenHistoricData", data: historicData!)
                    }
                }
                storeChangesForCryptoInUsd()
                completion(true)
            }
        } catch {
            print("Kraken - Error: \(error.localizedDescription)")
            completion(false)
        }
    }.resume()
}

// public func coinIsValid(name: String, completion: @escaping (Bool) -> Void) {
//    let apiKey = "50e5b41c-ec5c-47f5-88fd-9ab5f51ed210"
//    let urlString = "https://pro-api.coinmarketcap.com/v2/tools/price-conversion?symbol=\(name)&amount=1&convert=USD"
//
//    guard let url = URL(string: urlString) else {
//        print("Error creating URL")
//        return
//    }
//
//    var request = URLRequest(url: url)
//    request.httpMethod = "GET"
//    request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
//    request.addValue("application/json", forHTTPHeaderField: "Accept")
//
//    let task = URLSession.shared.dataTask(with: request) { _, response, error in
//        if let error {
//            print("coinIsValid - Error making request: \(error.localizedDescription)")
//            completion(false)
//            return
//        }
//
//        if let httpResponse = response as? HTTPURLResponse {
//            completion(httpResponse.statusCode != 400)
//        } else {
//            completion(false)
//        }
//    }
//
//    task.resume()
// }

// public func convertCoinToUSD(name: String, amount: Double, completion: @escaping (Double) -> Void) {
//    let apiKey = "8add797c9e72bef06bde41650b18ece2cb3a547c34f44ba6b32775ee769fac9a"
//    let url = "https://min-api.cryptocompare.com/data/price?fsym=\(name)&tsyms=USD"
//    var request = URLRequest(url: URL(string: url)!)
//    request.setValue(apiKey, forHTTPHeaderField: "Apikey")
//
//    let task = URLSession.shared.dataTask(with: request) { data, _, error in
//        guard let data, error == nil else {
//            print("Error: \(error?.localizedDescription ?? "Unknown error")")
//            completion(-1.0)
//            return
//        }
//
//        if let jsonResponse = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Double] {
//            if let price = jsonResponse["USD"] {
//                completion(round(price * amount * 100) / 100)
//            } else {
//                print("coinToUSD - Error: Unable to get price for \(name)")
//                completion(-1.0)
//            }
//        } else {
//            if let content = String(data: data, encoding: .utf8) {
//                print(content)
//            }
//            print("coinToUSD - Error: Cannot parse JSON response")
//            completion(-1.0)
//        }
//    }
//
//    task.resume()
// }
