//
//  StateRepository.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

extension State {
    struct Repository {
        static let initial = Repository(allRepositories: [])

        let allRepositories: [PeerlabPD.IRepository]
    }
}

func reduce(state: State.Repository, action: Action) -> State.Repository{
    guard let action = action as? RepositoriesDidLoad else {
        return state
    }
    //work with data if needed
    return State.Repository(allRepositories: action.repositories)
}
