//
//  ContentView_UITests.swift
//  CryptoUniversev2UITests
//
//  Created by Kirill Kostakov on 22.01.2023.
//

import XCTest

final class ContentView_Login_UITests: XCTestCase {
    let app = XCUIApplication()

    override func tearDownWithError() throws {
        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/
            .buttons["Перетянуть"]/*[[".otherElements[\"Перетянуть\"].buttons[\"Перетянуть\"]",".buttons[\"Перетянуть\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["Log Out"].tap()
    }

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        app.launch()
    }

    func test_ContentView_LogIn_ShouldLogIn() {
        app.textFields["Username"].tap()

        let rKey = app/*@START_MENU_TOKEN@*/
            .keys["r"]/*[[".keyboards.keys[\"r\"]",".keys[\"r\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        rKey.tap()

        let oKey = app/*@START_MENU_TOKEN@*/
            .keys["o"]/*[[".keyboards.keys[\"o\"]",".keys[\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        oKey.tap()

        let tKey = app/*@START_MENU_TOKEN@*/
            .keys["t"]/*[[".keyboards.keys[\"t\"]",".keys[\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        tKey.tap()
        app.secureTextFields["Password"].tap()
        rKey.tap()
        oKey.tap()
        oKey.tap()
        tKey.tap()
        app.buttons["Log In"].tap()
        let title = app.navigationBars["Crypto Universe"].staticTexts["Crypto Universe"]
        XCTAssertTrue(title.exists)
    }
}
