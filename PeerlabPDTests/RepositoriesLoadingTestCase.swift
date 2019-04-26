//
//  RepositoriesLoadingTestCase.swift
//  PeerlabPDTests
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import XCTest
@testable import PeerlabPD

class RepositoriesLoadingTestCase: XCTestCase {
    func testInitialState() {
		let state = State.initial
    	XCTAssertTrue(state.repositories.allRepositories.isEmpty)
		XCTAssertTrue(state.loading == .none)
    }

    func testLoadingSequence() {
		var state = State.initial

		state = reduce(state: state, action: RepositoriesStartLoading())

        XCTAssertEqual(state.loading, .loading)

        state = reduce(state: state, action: RepositoriesDidLoad(repositories: []))

        XCTAssertEqual(state.loading, .none)
    }
}
