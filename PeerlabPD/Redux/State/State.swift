//
//  State.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

struct State {
	static let initial = State(repositories: .initial, loading: .initial)

    var repositories: State.Repository
    var loading: State.Loading
}

func reduce(state: State, action: Action) -> State {
	return State(
        repositories: reduce(state: state.repositories, action: action),
        loading: reduce(state: state.loading, action: action)
    )
}
