//
//  CryptoUniversev2UITests.swift
//  CryptoUniversev2UITests
//
//  Created by Orest Haman on 10/12/2022.
//

import XCTest

final class CryptoUniversev2UITests: XCTestCase {
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        let app = XCUIApplication()
        app.launch()

        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
