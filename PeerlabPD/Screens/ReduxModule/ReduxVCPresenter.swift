//
//  ReduxVCPresenter.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

struct ReduxVCPresenter {
    let render: (ReduxViewController.Props)->()
    let dispatch: (Action)->()

    func handle(_ state: State) {
        switch state.loading {
        case .loading:
            render(ReduxViewController.Props.loading)
        default:
            render(ReduxViewController.Props.repositories(
                repositories: state.repositories.allRepositories.map {
                    ReduxViewController.Props.Repository(
                        name: $0.name ?? "",
                        descr: $0.repoDescription ?? "",
                        image: $0.avatarUrl)
                },
                refresh: Command {
					self.dispatch(RepositoriesStartLoading())
            	}
            ))
        }
    }
}
