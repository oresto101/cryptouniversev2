//
//  ContentView_UITests.swift
//  CryptoUniversev2UITests
//
//  Created by Kirill Kostakov on 22.01.2023.
//

import XCTest

final class ContentView_Login_UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        app.launch()
    }
}
