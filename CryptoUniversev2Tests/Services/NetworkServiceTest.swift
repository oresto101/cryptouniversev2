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
        parseBinance(apiKey: "WAMuw1z4yyTnFAEAuZgAAkCGJzwoCwYsp09XV1odgRiNDEwpx0nAt6fCjM5KEP1B", secretKey: "XcDz4ttqZZh1qPMwV44QRyeIiQAPGk0du7qJbCGdxG6iY1c1R82jmtPom1fOe7K2", newData: false) {
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
        parseOKX(apiKey: "5ccd0dbc-c2dd-4710-b8f5-ab588a9abc5e", secretKey: "A4F726B7DEFC5525D159A4B157142695", passphrase: "Nora2011!", newData: false) {
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
        parseGemini(apiKey: "account-b4ssyZsS9CAtclPvXTKN", secretKey: "3gsAFSkwCGnKY54uJzZZcHYrkSBL", newData: false) {
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
        parseKraken(apiKey: "C9J2q5YQAnlIjrtWIhTM2e5v64fSKQbhauCZ4LnBHYG/RB4LdX2A8sCB", secretKey: "ka3PjvoMWfT2PXsFCvuvVBj9zK00uZLBpm6VpaMZX0AjqgL9ZAl0TXUZ51NdWtuwZWgtV6SDe0qugo3r8zGVIA==", newData: false) {
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
