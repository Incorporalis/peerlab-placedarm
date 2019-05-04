//
//  SearchService.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import CoreData
import RxSwift

protocol ISearchService {

    var repositories: [IRepository]? {get}

    var getRepositoriesSignal: Observable<[IRepository]> { get }

}

class SearchService: ISearchService {

    var dbService: IDBService
	var repositories: [IRepository]?

    private var dispatcher: INetworkDispatcher

    init(with dispatcher: INetworkDispatcher, dbService: IDBService) {
        self.dispatcher = dispatcher
        self.dbService = dbService
    }

    var getRepositoriesSignal: Observable<[IRepository]> {
        let signal = Observable<[IRepository]>.create() { observer -> Disposable in
            let swiftRequest = SearchRequestOpeation()
            do {
                try swiftRequest.execute(in: self.dispatcher) {[weak self] (result) in
                    switch (result) {
                    case .success(let repos):
                        guard let self = self else { return }
                        
                        self.repositories = repos
                        let context = self.dbService.context
                        repos.forEach { repo in
                            context.performAndWait {
                                _ = repo.createEntity(in: context)
                            }
                        }
                        self.dbService.save()

// test
//                        let fr:NSFetchRequest<RepositoryManaged> = RepositoryManaged.fetchRequest()
//                        do {
//                            let reps = try context.fetch(fr)
//                            print(reps)
//                        } catch {
//                            print(error)
//                        }

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
