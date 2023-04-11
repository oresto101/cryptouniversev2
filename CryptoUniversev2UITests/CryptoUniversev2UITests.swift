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

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests
        // before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
