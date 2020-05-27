//
//  asdf.swift
//  asdf
//
//  Created by Ivan on 08/05/2019.
//

import XCTest

class asdf: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        continueAfterFailure = false
		app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {

    }

    func testExample() {
        let cell = app.cells.element(boundBy: 2)
        if (cell.waitForExistence(timeout: 10)) {
            XCTAssertEqual(cell.staticTexts.firstMatch.value as! String, "Name1")
        } else {
            XCTFail("There is no expected cell")
        }
    }

}
