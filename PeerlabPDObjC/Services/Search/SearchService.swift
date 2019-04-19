//
//  SearchService.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation
import RxSwift

protocol ISearchService {

    var repositories: [IRepository]? {get}

    var getRepositoriesSignal: Observable<[IRepository]> { get }

}

class SearchService: ISearchService {

	var repositories: [IRepository]?

    private var dispatcher: INetworkDispatcher

    init(with dispatcher: INetworkDispatcher) {
        self.dispatcher = dispatcher
    }

    var getRepositoriesSignal: Observable<[IRepository]> {
        let signal = Observable<[IRepository]>.create() { observer -> Disposable in
            let swiftRequest = SearchRequestOpeation()
            do {
                try swiftRequest.execute(in: self.dispatcher) {[weak self] (result) in
                    switch (result) {
                    case .success(let repos):
                        self?.repositories = repos
                        observer.on(.next(repos))
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
        return signal
    }

}
