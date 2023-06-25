//
//  NetworkServiceTest.swift
//  CryptoUniversev2Tests
//
//  Created by Orest Haman on 22/06/2023.
//

import XCTest

final class NetworkServiceTest: XCTestCase {

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

    func testParseBinance() throws {
        parseBinance(apiKey: "*", secretKey: "*", newData: false) {
            isValid in
            if isValid {
                let res = UserDefaults.standard.dictionary(forKey: "BinanceData")
                XCTAssertNotNil(res)
            } else {
                XCTFail()
            }
        }
    }
    
    func testParseOKX() throws {
        parseOKX(apiKey: "*", secretKey: "*", passphrase: "*", newData: false) {
            isValid in
            if isValid {
                let res = UserDefaults.standard.dictionary(forKey: "OKXData")
                XCTAssertNotNil(res)
            } else {
                XCTFail()
            }
        }
    }
    
    func testParseGemini() throws {
        parseGemini(apiKey: "*", secretKey: "*", newData: false) {
            isValid in
            if isValid {
                let res = UserDefaults.standard.dictionary(forKey: "GeminiData")
                XCTAssertNotNil(res)
            } else {
                XCTFail()
            }
        }
    }
    
    func testParseKraken() throws {
        parseKraken(apiKey: "*", secretKey: "*", newData: false) {
            isValid in
            if isValid {
                let res = UserDefaults.standard.dictionary(forKey: "KrakenData")
                XCTAssertNotNil(res)
            } else {
                XCTFail()
            }
        }
    }

}
