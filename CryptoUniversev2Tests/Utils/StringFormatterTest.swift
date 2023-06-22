//
//  StringFormatterTest.swift
//  CryptoUniversev2Tests
//
//  Created by Orest Haman on 11/06/2023.
//

import XCTest

final class StringFormatterTest: XCTestCase {
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testFormatPercentageToString() {
        var percentage = 10.0
        var result = formatPercentageToString(percentage: percentage)
        XCTAssertEqual(result, "+10.0%")

        percentage = -10.0
        result = formatPercentageToString(percentage: percentage)
        XCTAssertEqual(result, "-10.0%")
    }

    func testFormatBalancePLAndPercentageToString() {
        let balance = 1000.0
        var percentage = 10.0
        var result = formatBalancePLAndPercentageToString(balance: balance, percentage: percentage)
        XCTAssertEqual(result, "1000.0 $ (+10.0%)")

        percentage = -10.0
        result = formatBalancePLAndPercentageToString(balance: balance, percentage: percentage)
        XCTAssertEqual(result, "1000.0 $ (-10.0%)")
    }

    func testRoundDoubles() {
        let value = 10.12345
        let result = roundDoubles(val: value)
        XCTAssertEqual(result, 10.12)
    }
}
