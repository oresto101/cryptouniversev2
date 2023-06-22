//
//  CoinMarketCapServiceTest.swift
//  CryptoUniversev2Tests
//
//  Created by Orest Haman on 22/06/2023.
//

import XCTest

final class CoinMarketCapServiceTest: XCTestCase {

    override func setUpWithError() throws {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
    }

    override func tearDownWithError() throws {
                let domain = Bundle.main.bundleIdentifier!
                UserDefaults.standard.removePersistentDomain(forName: domain)
                UserDefaults.standard.synchronize()
    }

    func testExample() throws {
        let exchangesToBeParsed: [String: [String: Double]] = [
            "Manual": [
                "ETH": 23.0,
            ],
            "Gemini": [
                "ETH": 23.0,
            ],
            "OKX": [
                "BTC": 1,
                "BNB": 5,
                "ETH": 23.0,
            ],
            "Kraken": [
                "BTC": 1,
                "BNB": 5,
                "ETH": 23.0,
            ],
            "Binance": [
                "BTC": 1,
                "BNB": 5
            ],
        ]
        for (exchangeName, data) in exchangesToBeParsed {
            UserDefaults.standard.set(data, forKey: "\(exchangeName)Data")
        }
        
        storeChangesForCryptoInUsd() {
            isValid in
            if isValid {
                let prices = UserDefaults.standard.dictionary(forKey: "Prices")
                let priceChanges = UserDefaults.standard.dictionary(forKey: "PriceChanges")
                XCTAssertNotNil(prices)
                XCTAssertNotNil(priceChanges)
                XCTAssertTrue(prices!.keys.contains(["BTC", "BNB", "ETH"]))
                XCTAssertTrue(priceChanges!.keys.contains(["BTC", "BNB", "ETH"]))
            } else {
                XCTFail()
            }
        }
    }


}
