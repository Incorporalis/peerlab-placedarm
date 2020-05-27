//
//  PeerlabPOUITests.swift
//  PeerlabPOUITests
//
//  Created by Ivan on 08/05/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import XCTest

class PeerlabPOUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {

    }

    func testCellWithTextExists() {
        let cell = app.tables.element(boundBy: 0)
                   .cells.element(boundBy: 2)

        if (cell.waitForExistence(timeout: 2)) {
            let cellLabel = cell.staticTexts["Name1"]
            XCTAssertEqual(cellLabel.exists, true, "Should be shown")
        } else {
            XCTFail("There is no expected cell")
        }
    }

    func testNewScreenShowsRightInfoAfterTapToSecondCell() {
        let cell = app.tables.element(boundBy: 0)
            .cells.element(boundBy: 2)

        if (cell.waitForExistence(timeout: 2)) {
            cell.tap()
        } else {
            XCTFail("There is no expected cell")
        }

        let newScreen = app.navigationBars["Name1"]
        if (newScreen.waitForExistence(timeout: 2)) {
            let descr = app.staticTexts["Description"]
            XCTAssertEqual(descr.exists, true, "Should be shown properly")
        } else {
            XCTFail("There is no exected screen")
        }
    }

}
