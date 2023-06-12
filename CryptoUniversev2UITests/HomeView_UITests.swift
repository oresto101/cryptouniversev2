//
//  HomeView_UITests.swift
//  CryptoUniversev2UITests
//
//  Created by Kirill Kostakov on 22.01.2023.
//

import XCTest

final class HomeView_UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        app.launch()
    }

    func test_HomeView_Page_ShouldLoadData() {
        
    }

    func test_HomeView_Action_ShouldCloseHelp() {
        
    }

    func test_HomeView_Action_ExchangeAction() {
        
    }

    func test_HomeView_Action_FailExchangeAction() {
        
    }

    func test_HomeView_Action_FailManualCcy() {
        
    }

    func test_HomeView_Action_ManualCcy() {

    }
}
