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
        let collectionViewsQuery = XCUIApplication().collectionViews
        app.navigationBars["Crypto Universe"].staticTexts["Crypto Universe"].tap()
        let scrollViewsQuery = collectionViewsQuery/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.scrollViews
        let element_wait = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element_wait)
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").children(matching: .other).element
        element.swipeLeft()
        let element2 = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Binance").children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element2)
        let removeexchangeButton = scrollViewsQuery.otherElements.buttons["RemoveExchange"]
        removeexchangeButton.tap()
        XCTAssertTrue(collectionViewsQuery/*@START_MENU_TOKEN@*/ .buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.waitForExistence(timeout: 5))
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
        app.navigationBars["Crypto Universe"].buttons["Drag"].tap()
        app.buttons["Add Cryptoexchange"].tap()
        let exchanges = [
                    ExchangeForList(id: "1", name: "Binance", logo: "binance_logo"),
                    ExchangeForList(id: "2", name: "OKX", logo: "okx_logo"),
                    ExchangeForList(id: "4", name: "Gemini", logo: "gemini_logo"),
                    ExchangeForList(id: "5", name: "Kraken", logo: "kraken_logo")
                ]
        
        for exchange in exchanges {
                    let exchangeCard = app.staticTexts[exchange.name]
                    XCTAssertTrue(exchangeCard.exists)
                }
        
        let firstExchangeCard = app.staticTexts[exchanges[0].name]
        XCTAssertTrue(firstExchangeCard.waitForExistence(timeout: 5))
        firstExchangeCard.tap()
        
        let selectedExchangeLabel = app.staticTexts[exchanges[0].name]
        XCTAssertTrue(selectedExchangeLabel.waitForExistence(timeout: 5))
        
        let collectionViewsQuery = app.collectionViews
        
        let exchangeAPI = collectionViewsQuery.secureTextFields["Exchange API"]
        let exchangeSecret = collectionViewsQuery.secureTextFields["Exchange Secret"]
                
        exchangeAPI.tap()
        exchangeAPI.typeText("WAMuw1z4yyTnFAEAuZgAAkCGJzwoCwYsp09XV1odgRiNDEwpx0nAt6fCjM5KEP1B")
                
        exchangeSecret.tap()
        exchangeSecret.typeText("XcDz4ttqZZh1qPMwV44QRyeIiQAPGk0du7qJbCGdxG6iY1c1R82jmtPom1fOe7K2")

        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Add Cryptoexchange"].tap()
        
        app.navigationBars["Crypto Universe"].staticTexts["Crypto Universe"].tap()
        let scrollViewsQuery = app.collectionViews/*@START_MENU_TOKEN@*/ .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements.scrollViews
        let element_wait = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element_wait)
        
    }

    func test_HomeView_Action_FailExchange() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"].buttons["Drag"].tap()
        app.buttons["Add Cryptoexchange"].tap()
        let exchanges = [
                    ExchangeForList(id: "1", name: "Binance", logo: "binance_logo"),
                    ExchangeForList(id: "2", name: "OKX", logo: "okx_logo"),
                    ExchangeForList(id: "4", name: "Gemini", logo: "gemini_logo"),
                    ExchangeForList(id: "5", name: "Kraken", logo: "kraken_logo")
                ]
        
        for exchange in exchanges {
                    let exchangeCard = app.staticTexts[exchange.name]
                    XCTAssertTrue(exchangeCard.exists)
                }
        
        let firstExchangeCard = app.staticTexts[exchanges[0].name]
        XCTAssertTrue(firstExchangeCard.waitForExistence(timeout: 5))
        firstExchangeCard.tap()
        
        let selectedExchangeLabel = app.staticTexts[exchanges[0].name]
        XCTAssertTrue(selectedExchangeLabel.waitForExistence(timeout: 5))
        
        let collectionViewsQuery = app.collectionViews
        
        let exchangeAPI = collectionViewsQuery.secureTextFields["Exchange API"]
        let exchangeSecret = collectionViewsQuery.secureTextFields["Exchange Secret"]
                
        exchangeAPI.tap()
        exchangeAPI.typeText("b")
        exchangeSecret.tap()
        exchangeSecret.typeText("b")

        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Add Cryptoexchange"].tap()
        
        let elementsQuery = app.alerts["Fake Credentials"].scrollViews.otherElements
        elementsQuery.staticTexts["Fake Credentials"].tap()
        let alert = elementsQuery.element.exists
        elementsQuery.buttons["Dismiss"].tap()
        XCTAssertTrue(alert)

    }

    func test_HomeView_Action_ManualCcy() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/.buttons["Drag"]/*[[".otherElements[\"Drag\"].buttons[\"Drag\"]",".buttons[\"Drag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Add Cryptocurrency"].tap()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.collectionViews.textFields["Cryptocurrency Code"]/*[[".cells.collectionViews",".cells.textFields[\"Cryptocurrency Code\"]",".textFields[\"Cryptocurrency Code\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        let shiftButton = app/*@START_MENU_TOKEN@*/.buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        shiftButton.tap()
        app/*@START_MENU_TOKEN@*/.keys["S"]/*[[".keyboards.keys[\"S\"]",".keys[\"S\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        shiftButton.tap()
        let oKey = app/*@START_MENU_TOKEN@*/.keys["O"]/*[[".keyboards.keys[\"O\"]",".keys[\"O\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        oKey.tap()
        shiftButton.tap()
        let lKey = app/*@START_MENU_TOKEN@*/.keys["L"]/*[[".keyboards.keys[\"L\"]",".keys[\"L\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lKey.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.collectionViews.textFields["Quantity"]/*[[".cells.collectionViews",".cells.textFields[\"Quantity\"]",".textFields[\"Quantity\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.collectionViews.buttons["Add Cryptocurrency"]/*[[".cells.collectionViews",".cells.buttons[\"Add Cryptocurrency\"]",".buttons[\"Add Cryptocurrency\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        let scrollViewsQuery = collectionViewsQuery/*@START_MENU_TOKEN@*/.scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.scrollViews
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Overall").children(matching: .other).element
        element.swipeLeft()
        let element2 = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Binance").children(matching: .other).element
        element2.swipeLeft()
        let element3 = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Manual").children(matching: .other).element.exists
        XCTAssertTrue(element3)

        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Manual").children(matching: .other).element.children(matching: .button).matching(identifier: "RemoveExchange").element(boundBy: 0).tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        XCTAssertTrue(element.waitForExistence(timeout: 30))
    }


    func test_HomeView_Action_FailManualCcy() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/.buttons["Drag"]/*[[".otherElements[\"Drag\"].buttons[\"Drag\"]",".buttons[\"Drag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Add Cryptocurrency"].tap()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.collectionViews.textFields["Cryptocurrency Code"]/*[[".cells.collectionViews",".cells.textFields[\"Cryptocurrency Code\"]",".textFields[\"Cryptocurrency Code\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        let fKey = app/*@START_MENU_TOKEN@*/.keys["f"]/*[[".keyboards.keys[\"f\"]",".keys[\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        fKey.tap()
        fKey.tap()
        fKey.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.collectionViews.textFields["Quantity"]/*[[".cells.collectionViews",".cells.textFields[\"Quantity\"]",".textFields[\"Quantity\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".keyboards.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.collectionViews.buttons["Add Cryptocurrency"]/*[[".cells.collectionViews",".cells.buttons[\"Add Cryptocurrency\"]",".buttons[\"Add Cryptocurrency\"]",".collectionViews"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        let elementsQuery = app.alerts["Cryptocurrency doesn't exist"].scrollViews.otherElements
        XCTAssertTrue(elementsQuery.staticTexts["Cryptocurrency doesn't exist"].exists)
        elementsQuery.buttons["Dismiss"].tap()
    }

    func test_HomeView_Action_NewsPage() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/ .buttons["Drag"]/*[[".otherElements[\"Drag\"].buttons[\"Drag\"]",".buttons[\"Drag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["News"].tap()
        let newsItem = app.scrollViews.children(matching: .any).firstMatch
        XCTAssertTrue(newsItem.exists)
        newsItem.tap()
        let bottombrowsertoolbarToolbar = app.toolbars["BottomBrowserToolbar"]
        XCTAssertTrue(bottombrowsertoolbarToolbar.waitForExistence(timeout: 10))
    }
    
    func test_HomeView_Action_HelpPage() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/ .buttons["Drag"]/*[[".otherElements[\"Drag\"].buttons[\"Drag\"]",".buttons[\"Drag\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["Help"].tap()
        let addExchangeGroup = app.buttons["Can I use the app without an Internet?"]
        XCTAssertTrue(addExchangeGroup.waitForExistence(timeout: 5))
        addExchangeGroup.tap()
        let addExchangeAnswer = app.staticTexts["Internet conection is strongly reqired to use CryptoUniverse App."]
        XCTAssertTrue(addExchangeAnswer.waitForExistence(timeout: 5))
    }
    
    func test_HomeView_Action_AddExchangeHelp() {
        let app = XCUIApplication()
        app.navigationBars["Crypto Universe"].buttons["Drag"].tap()
        app.buttons["Add Cryptoexchange"].tap()
        let exchanges = [
            ExchangeForList(id: "1", name: "Binance", logo: "binance_logo")
        ]
        
        let firstExchangeCard = app.staticTexts[exchanges[0].name]
        firstExchangeCard.tap()
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["questionmark.circle"].tap()
        let bottombrowsertoolbarToolbar = app.toolbars["BottomBrowserToolbar"]
        XCTAssertTrue(bottombrowsertoolbarToolbar.waitForExistence(timeout: 10))
    }
    
    func test_HomeView_Action_NetworkScreen() {
        let app = XCUIApplication()
        
        let controlCenter = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        
        // open control center
        let coord1 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.01))
        let coord2 = app.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.2))
        coord1.press(forDuration: 0.1, thenDragTo: coord2)

        let airplaneModeButton = controlCenter.switches["airplane-mode-button"]
        airplaneModeButton.tap()
        let empty = controlCenter.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.05))
        empty.tap()
        
        XCTAssertTrue(app.images["Warning"].waitForExistence(timeout: 5))
        
        coord1.press(forDuration: 0.1, thenDragTo: coord2)
        airplaneModeButton.tap()
        empty.tap()
        
        let scrollViewsQuery = app.collectionViews.otherElements.scrollViews
        let element = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").children(matching: .other).element.waitForExistence(timeout: 30)
        XCTAssertTrue(element)
    }
}
