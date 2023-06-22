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
        let app = XCUIApplication()
        let scrollViewsQuery = app.collectionViews/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.scrollViews
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element)
    }

    func test_HomeView_Action_HomePage() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"].staticTexts["Crypto Universe"].tap()
        let scrollViewsQuery = app.collectionViews/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.scrollViews
        let element_wait = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element_wait)
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").children(matching: .other).element
        element.swipeLeft()
        let element2 = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Binance").children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element2)
        XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.scrollViews.otherElements
            .buttons["RemoveExchange"].tap()
        let remButton = app.collectionViews/*@START_MENU_TOKEN@*/ .buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertEqual(element2, remButton)
    }

    func test_HomeView_Action_RemoveExchange() {
        let collectionViewsQuery = XCUIApplication().collectionViews
        let scrollViewsQuery = collectionViewsQuery/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").element.swipeLeft()
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "Binance").children(matching: .other).element.swipeLeft()
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "OKX").children(matching: .other).element.swipeLeft()
        scrollViewsQuery.otherElements.containing(.staticText, identifier: "Kraken").children(matching: .other).element.swipeLeft()
        let removeexchangeButton = scrollViewsQuery.otherElements.buttons["RemoveExchange"]
        removeexchangeButton.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/ .buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .tap()
        let overallElem = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").element.children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(overallElem)
    }

    func test_HomeView_Action_AddExchange() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/ .buttons["Drag"]/*[[".otherElements[\"Drag\"].buttons[\"Drag\"]",".buttons[\"Drag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["Add Cryptoexchange"].tap()
    }

    func test_HomeView_Action_FailExchange() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"].buttons["Drag"].tap()
        app.buttons["Add Cryptoexchange"].tap()
        
        
        
    }

    func test_HomeView_Action_RemoveManualCcy() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"].buttons["Drag"].tap()
        app.buttons["Add Cryptoexchange"].tap()
    }

    func test_HomeView_Action_AddManualCcy() {}

    func test_HomeView_Action_FailManualCcy() {}

    func test_HomeView_Action_NewsPage() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/ .buttons["Drag"]/*[[".otherElements[\"Drag\"].buttons[\"Drag\"]",".buttons[\"Drag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["News"].tap()
        let element = app.navigationBars["Crypto Universe"].staticTexts["News"].children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element)
    }
}
