//
//  RepositoriesLoadingController.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation
import RxSwift

class RepositoriesLoadingController {
    let service: ISearchService
    let dispatch: (Action) -> ()

	private let bag = DisposeBag()
    private var isLoading = false

    init(service: ISearchService, dispatch: @escaping (Action) -> ()) {
        self.service = service
        self.dispatch = dispatch

        dispatch(RepositoriesStartLoading())
    }

    func handle(_ state: State) {
        guard case .loading = state.loading else {
            return
        }

        guard !isLoading else {
            return
        }

        isLoading = true
        service.getRepositoriesSignal.subscribe(onNext: {
			self.dispatch(RepositoriesDidLoad(repositories: $0))
            self.isLoading = false
        }, onError: {
            self.dispatch(RepositoriesFailLoading(error: $0.localizedDescription))
            self.isLoading = false
        }).disposed(by: bag)
    }

}
