//
//  SearchViperInteractor.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import CoreData
import RxSwift

protocol ISearchViperInteractorInput: class {

    func configure(with output: ISearchViperInteractorOutput)
	func startDataLoading()

}

protocol ISearchViperInteractorOutput: class {

    func didLoadData(with repositories: [IRepository]?)
    func didFailLoadData(with error: Error)

}

class SearchViperInteractor: ISearchViperInteractorInput {

    weak var output: ISearchViperInteractorOutput?
    private let searchService: ISearchService
    private let dbService: IDBService
    private let bag = DisposeBag()

    init(with search: ISearchService, dbService: IDBService) {
        self.searchService = search
        self.dbService = dbService
    }

    func configure(with output: ISearchViperInteractorOutput) {
        self.output = output
    }

	func startDataLoading() {
        let fr:NSFetchRequest<RepositoryManaged> = RepositoryManaged.fetch()
        fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        let reps = try? dbService.context.fetch(fr)
        output?.didLoadData(with: reps)

        searchService.getRepositoriesSignal
            .subscribe(onNext: { _ in
//                self?.output?.didLoadData(with: $0)
                	let fr:NSFetchRequest<RepositoryManaged> = RepositoryManaged.fetch()
                	fr.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
                	let reps = try? self.dbService.context.fetch(fr)
					self.output?.didLoadData(with: reps)
                }, onError: { [weak self] in
					self?.output?.didFailLoadData(with: $0)
            })
            .disposed(by: bag)
    }

}
