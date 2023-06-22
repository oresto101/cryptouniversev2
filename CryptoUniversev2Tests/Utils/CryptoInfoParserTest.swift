//
//  CryptoInfoParserTest.swift
//  CryptoUniversev2Tests
//
//  Created by Orest Haman on 22/06/2023.
//

import XCTest

final class CryptoInfoParserTest: XCTestCase {

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

    func testRetrieveDataAndParseCryptoInfo() {
            UserDefaults.standard.set(["BTC": 50000.0], forKey: "Prices")
            UserDefaults.standard.set(["BTC": 2.5], forKey: "PriceChanges")
            UserDefaults.standard.set(["BTC": 2.5], forKey: "BinanceData")


            let result = retrieveDataAndParseCryptoInfo()

            XCTAssertFalse(result.0.isEmpty, "InfoBoxes should not be empty")
            XCTAssertFalse(result.1.isEmpty, "CryptoInfo should not be empty")
            XCTAssertTrue(result.0[0].name=="Overall")
            XCTAssertTrue(result.0[1].name=="Binance")
            XCTAssertTrue(result.1.keys.contains("Overall"))
            XCTAssertTrue(result.1.keys.contains("Binance"))
            XCTAssertFalse(result.2, "noData should be false")
        }
    
    func testExtremeRetreiveDataAndParseCryptoInfo() {
        // Set up the expected return values
        
        let expectedCryptoInfo = ["Kraken": [CryptoInfo(name: "ETH", balance: 43723.0, amount: 23.0, price: 1901.0, dailyProfitLoss: 3.0), CryptoInfo(name: "BTC", balance: 30266.0, amount: 1.0, price: 30266.0, dailyProfitLoss: 3.0), CryptoInfo(name: "BNB", balance: 1240.0, amount: 5.0, price: 248.0, dailyProfitLoss: 0.0)], "OKX": [CryptoInfo(name: "ETH", balance: 43723.0, amount: 23.0, price: 1901.0, dailyProfitLoss: 3.0), CryptoInfo(name: "BTC", balance: 30266.0, amount: 1.0, price: 30266.0, dailyProfitLoss: 3.0), CryptoInfo(name: "BNB", balance: 1240.0, amount: 5.0, price: 248.0, dailyProfitLoss: 0.0)], "Overall": [CryptoInfo(name: "ETH", balance: 174892.0, amount: 92.0, price: 1901.0, dailyProfitLoss: 3.0), CryptoInfo(name: "BTC", balance: 90798.0, amount: 3.0, price: 30266.0, dailyProfitLoss: 3.0), CryptoInfo(name: "BNB", balance: 3720.0, amount: 15.0, price: 248.0, dailyProfitLoss: 0.0)], "Binance": [CryptoInfo(name: "BTC", balance: 30266.0, amount: 1.0, price: 30266.0, dailyProfitLoss: 3.0), CryptoInfo(name: "BNB", balance: 1240.0, amount: 5.0, price: 248.0, dailyProfitLoss: 0.0)], "Manual": [CryptoInfo(name: "ETH", balance: 43723.0, amount: 23.0, price: 1901.0, dailyProfitLoss: 3.0)], "Gemini": [CryptoInfo(name: "ETH", balance: 43723.0, amount: 23.0, price: 1901.0, dailyProfitLoss: 3.0)]]
               
               let cryptoPrices: [String: Double] = [
                   "ETH": 1901,
                   "BTC": 30266,
                   "BNB": 248
               ]

               let priceChanges: [String: Double] = [
                   "ETH": 3,
                   "BTC": 3,
                   "BNB": 0,
               ]
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

        UserDefaults.standard.set(cryptoPrices, forKey: "Prices")
        UserDefaults.standard.set(priceChanges, forKey: "PriceChanges")
        for (exchangeName, data) in exchangesToBeParsed {
            UserDefaults.standard.set(data, forKey: "\(exchangeName)Data")
        }
        
        let result = retrieveDataAndParseCryptoInfo()
        
        XCTAssertEqual(result.1, expectedCryptoInfo)
        XCTAssertEqual(result.2, false)
    }

        func testGetExchangesToBeParsed() {
            UserDefaults.standard.set(["BTC": 2.5], forKey: "BinanceData")

            let result = getExchangesToBeParsed()

            XCTAssertEqual(result.count, 1, "ExchangesToBeParsed count should be 1")
            XCTAssertNotNil(result["Binance"], "ExchangesToBeParsed should contain 'BinanceData'")
            XCTAssertEqual(result["Binance"]?.count, 1, "BinanceData count should be 1")
            XCTAssertEqual(result["Binance"]?["BTC"], 2.5, "BinanceData BTC value should be 2.5")
        }

}
