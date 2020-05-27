//
//  PeerlabPDTests.swift
//  PeerlabPDTests
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import XCTest
@testable import PeerlabPD

class PeerlabPDTests: XCTestCase {

    func testParsingsdf() {
		//given
        let dict = [
            "name" : "Name1",
            "surname" : "Surname1",
            "imageUrl" : "https://google.com"
		]
    	//when
        let obj = Object(with: dict)

        //then
        XCTAssertEqual(obj.name, "Name1", "should be equal")
        XCTAssertEqual(obj.surname, "Surname1", "should be equal")
        XCTAssertEqual(obj.imageUrl?.absoluteString, "https://google.com", "should be equal")
    }

}

struct Object {

    let name: String
    let surname: String
    let imageUrl: URL?

    init(with json: [String : Any]) {
		self.name = json["name"] as? String ?? ""
        self.surname = json["surname"] as? String ?? ""
        let link = json["imageUrl"] as? String ?? ""
        self.imageUrl = URL(string: link)
    }

}
