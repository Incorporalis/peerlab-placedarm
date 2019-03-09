//
//  StateLoading.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

extension State {
    enum Loading: Equatable {
        static let initial = Loading.none
        
        case none
        case loading
        case error(message: String)
    }
}

func reduce(state: State.Loading, action: Action) -> State.Loading {
    switch action {
    case is RepositoriesStartLoading:
        return .loading
    case is RepositoriesDidLoad:
        return .none
    case let action as RepositoriesFailLoading:
        return .error(message: action.error)
    default:
     	return state
    }
}
