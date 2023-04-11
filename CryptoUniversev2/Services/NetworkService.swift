import CryptoKit
import Foundation
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

public func parseOKX(apiKey: String, secretKey: String, passphrase: String, completion: @escaping (Bool) -> Void) {
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    let timestamp = dateFormatter.string(from: Date())

    let method = "GET"
    let path = "/api/v5/account/balance"
    let message = "\(timestamp)\(method)\(path)"

    guard let secretKeyData = secretKey.data(using: .utf8),
          let messageData = message.data(using: .utf8)
    else {
        print("Error converting strings to data")
        return
    }

    let signature = HMAC<SHA256>.authenticationCode(for: messageData, using: SymmetricKey(data: secretKeyData))
    let signatureBase64 = Data(signature).base64EncodedString()

    guard let url = URL(string: "https://www.okx.com/api/v5/account/balance") else {
        print("Error creating URL")
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

        guard let data = data,
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let responseData = json["data"] as? [[String: Any]],
              let details = responseData.first?["details"] as? [[String: Any]]
        else {
            print("Error parsing JSON")
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

        completion(true)
    }

    task.resume()
}


func parseGemini(apiKey: String, secretKey: String, completion: @escaping (Bool) -> Void) {
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
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            print("Request error: ", error)
            completion(false)
            return
        }
        
        guard let data = data else { return }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                var res: [String: Double] = [:]
                for ccy in json {
                    if let currency = ccy["currency"] as? String, let amountString = ccy["amount"] as? String, let amount = Double(amountString) {
                        res[currency] = amount
                    }
                }
                completion(false)
            }
        } catch {
            completion(false)
            print("JSON parsing error: ", error)
        }
    }
    
    task.resume()
}


public func coinIsValid(name: String, completion: @escaping (Bool) -> Void) {
    let apiKey = "50e5b41c-ec5c-47f5-88fd-9ab5f51ed210"
    let urlString = "https://pro-api.coinmarketcap.com/v2/tools/price-conversion?symbol=\(name)&amount=1&convert=USD"

    guard let url = URL(string: urlString) else {
        print("Error creating URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue(apiKey, forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    request.addValue("application/json", forHTTPHeaderField: "Accept")

    let task = URLSession.shared.dataTask(with: request) { _, response, error in
        if let error = error {
            print("Error making request: \(error.localizedDescription)")
            completion(false)
            return
        }

        if let httpResponse = response as? HTTPURLResponse {
            completion(httpResponse.statusCode != 400)
        } else {
            completion(false)
        }
    }

    task.resume()
}
