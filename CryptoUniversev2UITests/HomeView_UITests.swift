//
//  HomeView_UITests.swift
//  CryptoUniversev2UITests
//
//  Created by Kirill Kostakov on 22.01.2023.
//

import XCTest

final class HomeView_UITests: XCTestCase {
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

    func test_HomeView_Page_ShouldLoadData() {
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

        let data = app.collectionViews/*@START_MENU_TOKEN@*/
            .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements
            .scrollViews.otherElements.containing(
                .staticText,
                identifier: "Overall"
            ).children(matching: .other).element.waitForExistence(timeout: 30)

        XCTAssertTrue(data)
    }

    func test_HomeView_Action_ShouldCloseHelp() {
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

        let cryptoUniverseNavigationBar = app.navigationBars["Crypto Universe"]
        let button = cryptoUniverseNavigationBar/*@START_MENU_TOKEN@*/
            .buttons["Перетянуть"]/*[[".otherElements[\"Перетянуть\"].buttons[\"Перетянуть\"]",".buttons[\"Перетянуть\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        button.tap()

        let helpButton = app.buttons["Help"]
        helpButton.tap()

        let cryptoUniverseButton = app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Crypto Universe"]
        cryptoUniverseButton.tap()

        XCTAssertTrue(cryptoUniverseNavigationBar.staticTexts["Crypto Universe"].exists)
    }

    func test_HomeView_Action_ExchangeAction() {
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

        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/
            .buttons["Перетянуть"]/*[[".otherElements[\"Перетянуть\"].buttons[\"Перетянуть\"]",".buttons[\"Перетянуть\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["Add Cryptoexchange"].tap()

        let collectionViewsQuery = app.collectionViews
        let exchangeAPI = collectionViewsQuery/*@START_MENU_TOKEN@*/
            .textFields["Exchange API"]/*[[".cells.textFields[\"Exchange API\"]",".textFields[\"Exchange API\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let exchangeSecret = collectionViewsQuery/*@START_MENU_TOKEN@*/
            .textFields["Exchange Secret"]/*[[".cells.textFields[\"Exchange Secret\"]",".textFields[\"Exchange Secret\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        exchangeAPI.tap()
        exchangeAPI.typeText("WAMuw1z4yyTnFAEAuZgAAkCGJzwoCwYsp09XV1odgRiNDEwpx0nAt6fCjM5KEP1B")

        exchangeSecret.tap()
        exchangeSecret.typeText("XcDz4ttqZZh1qPMwV44QRyeIiQAPGk0du7qJbCGdxG6iY1c1R82jmtPom1fOe7K2")

        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .buttons["Add cryptoexchange"]/*[[".cells.buttons[\"Add cryptoexchange\"]",".buttons[\"Add cryptoexchange\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        sleep(35)

        let scrollViewsQuery = collectionViewsQuery/*@START_MENU_TOKEN@*/
            .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements
            .scrollViews
        let overallElement = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Overall").element
        overallElement.swipeLeft()

        let okxElement = scrollViewsQuery.otherElements.containing(.staticText, identifier: "OKX").element
        okxElement.swipeLeft()

        let binanceElement = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Binance").element

        let ccyAdded = binanceElement.exists

        scrollViewsQuery.otherElements.buttons["RemoveExchange"].tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        overallElement.swipeLeft()
        okxElement.swipeLeft()

        let ccyRemoved = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Kraken").element.exists

        XCTAssertEqual(ccyRemoved, ccyAdded)
    }

    func test_HomeView_Action_FailExchangeAction() {
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

        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/
            .buttons["Перетянуть"]/*[[".otherElements[\"Перетянуть\"].buttons[\"Перетянуть\"]",".buttons[\"Перетянуть\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["Add Cryptoexchange"].tap()

        let collectionViewsQuery2 = app.collectionViews
        let exchangeApiTextField = collectionViewsQuery2/*@START_MENU_TOKEN@*/
            .textFields["Exchange API"]/*[[".cells.textFields[\"Exchange API\"]",".textFields[\"Exchange API\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        exchangeApiTextField.tap()

        let aKey = app/*@START_MENU_TOKEN@*/
            .keys["a"]/*[[".keyboards.keys[\"a\"]",".keys[\"a\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()

        let collectionViewsQuery = collectionViewsQuery2
        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .textFields["Exchange Secret"]/*[[".cells.textFields[\"Exchange Secret\"]",".textFields[\"Exchange Secret\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let bKey = app/*@START_MENU_TOKEN@*/
            .keys["b"]/*[[".keyboards.keys[\"b\"]",".keys[\"b\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        bKey.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .buttons["Add cryptoexchange"]/*[[".cells.buttons[\"Add cryptoexchange\"]",".buttons[\"Add cryptoexchange\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let elementsQuery = app.alerts["Fake credentials"].scrollViews.otherElements
        elementsQuery.staticTexts["Fake credentials"].tap()
        let alert = elementsQuery.element.exists
        elementsQuery.buttons["Dismiss"].tap()
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Crypto Universe"].tap()

        XCTAssertTrue(alert)
    }

    func test_HomeView_Action_FailManualCcy() {
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

        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/
            .buttons["Перетянуть"]/*[[".otherElements[\"Перетянуть\"].buttons[\"Перетянуть\"]",".buttons[\"Перетянуть\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["Add Cryptocurrency"].tap()

        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .textFields["Cryptocurrency code"]/*[[".cells.textFields[\"Cryptocurrency code\"]",".textFields[\"Cryptocurrency code\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let shiftButton = app/*@START_MENU_TOKEN@*/
            .buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        shiftButton.tap()

        let fKey = app/*@START_MENU_TOKEN@*/
            .keys["F"]/*[[".keyboards.keys[\"F\"]",".keys[\"F\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        fKey.tap()
        shiftButton.tap()

        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .textFields["Quantity"]/*[[".cells.textFields[\"Quantity\"]",".textFields[\"Quantity\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let key = app/*@START_MENU_TOKEN@*/
            .keys["Удалить"]/*[[".keyboards.keys[\"Удалить\"]",".keys[\"Удалить\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()

        let key2 = app/*@START_MENU_TOKEN@*/
            .keys["1"]/*[[".keyboards.keys[\"1\"]",".keys[\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()

        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .buttons["Add cryptocurrency"]/*[[".cells.buttons[\"Add cryptocurrency\"]",".buttons[\"Add cryptocurrency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let elementsQuery = app.alerts["Cryptocurrency doesn't exist"].scrollViews.otherElements
        elementsQuery.staticTexts["Cryptocurrency doesn't exist"].tap()
        let alert = elementsQuery.element.exists
        elementsQuery.buttons["Dismiss"].tap()
        app.navigationBars["_TtGC7SwiftUI19UIHosting"].buttons["Crypto Universe"].tap()

        XCTAssertTrue(alert)
    }

    func test_HomeView_Action_ManualCcy() {
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

        _ = app.collectionViews/*@START_MENU_TOKEN@*/
            .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ .otherElements
            .scrollViews.otherElements.containing(
                .staticText,
                identifier: "Overall"
            ).children(matching: .other).element.waitForExistence(timeout: 30)

        app.navigationBars["Crypto Universe"]/*@START_MENU_TOKEN@*/
            .buttons["Перетянуть"]/*[[".otherElements[\"Перетянуть\"].buttons[\"Перетянуть\"]",".buttons[\"Перетянуть\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()
        app.buttons["Add Cryptocurrency"].tap()

        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .textFields["Cryptocurrency code"]/*[[".cells.textFields[\"Cryptocurrency code\"]",".textFields[\"Cryptocurrency code\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let shiftButton = app/*@START_MENU_TOKEN@*/
            .buttons["shift"]/*[[".keyboards.buttons[\"shift\"]",".buttons[\"shift\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        shiftButton.tap()

        let aKey = app/*@START_MENU_TOKEN@*/
            .keys["A"]/*[[".keyboards.keys[\"A\"]",".keys[\"A\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        aKey.tap()

        let dKey = app/*@START_MENU_TOKEN@*/
            .keys["D"]/*[[".keyboards.keys[\"D\"]",".keys[\"D\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        shiftButton.tap()
        dKey.tap()
        shiftButton.tap()
        aKey.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .textFields["Quantity"]/*[[".cells.textFields[\"Quantity\"]",".textFields[\"Quantity\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let key = app/*@START_MENU_TOKEN@*/
            .keys["Удалить"]/*[[".keyboards.keys[\"Удалить\"]",".keys[\"Удалить\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()

        let key2 = app/*@START_MENU_TOKEN@*/
            .keys["5"]/*[[".keyboards.keys[\"5\"]",".keys[\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key2.tap()

        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .buttons["Add cryptocurrency"]/*[[".cells.buttons[\"Add cryptocurrency\"]",".buttons[\"Add cryptocurrency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        let scrollViewsQuery = collectionViewsQuery/*@START_MENU_TOKEN@*/
            .scrollViews/*[[".cells.scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        sleep(30)

        let scrollViewsQuery2 = scrollViewsQuery.otherElements.scrollViews
        scrollViewsQuery2.otherElements.containing(.staticText, identifier: "Overall").element.swipeLeft()
        scrollViewsQuery2.otherElements.containing(.staticText, identifier: "OKX").children(matching: .other).element
            .swipeLeft()
//        scrollViewsQuery2.otherElements.containing(.staticText, identifier:"Binance").children(matching:
//        .other).element.swipeLeft()
        scrollViewsQuery2.otherElements.containing(.staticText, identifier: "Kraken").children(matching: .other).element
            .swipeLeft()
        let elementsQuery = scrollViewsQuery2.otherElements
        let new_coin = elementsQuery.staticTexts["ADA"]
        let coin_created = new_coin.exists

        let element3 = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Manual")
            .children(matching: .other).element
        element3.children(matching: .button).matching(identifier: "RemoveExchange").element(boundBy: 1).tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/
            .buttons["Delete"]/*[[".cells.buttons[\"Delete\"]",".buttons[\"Delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
            .tap()

        XCTAssertNotEqual(coin_created, new_coin.exists)
    }
}
