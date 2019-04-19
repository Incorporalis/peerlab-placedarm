//
//  PeerlabPDObjCUITests.swift
//  PeerlabPDObjCUITests
//
//  Created by Ivan on 13/04/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import XCTest

class PeerlabPDObjCUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = true

        let app = XCUIApplication()
        setupSnapshot(app)
        app.launchArguments += ProcessInfo.processInfo.arguments
        app.launch()

    }

    func testFirstScreen() {
        let app = XCUIApplication()
		let cell = app.tables.firstMatch.cells.firstMatch
        if (cell.waitForExistence(timeout: 5)){
            snapshot("01MainScreen")
        }
    }

    func testSecondScreen() {
        let app = XCUIApplication()
		let cell = app.tables.element(boundBy: 0).cells.element(boundBy: 5)
            cell.swipeUp()

        if (cell.waitForExistence(timeout: 5)) {
        	cell.tap()
        }
		sleep(1)
        snapshot("02DetailsScreen")
    }

}
