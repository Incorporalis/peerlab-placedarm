//
//  SearchViperInteractor.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation
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
    private let bag = DisposeBag()

    init(with search: ISearchService) {
        self.searchService = search
    }

    func configure(with output: ISearchViperInteractorOutput) {
        self.output = output
    }

	func startDataLoading() {
        searchService.getRepositoriesSignal
            .subscribe(onNext: { [weak self] in
                self?.output?.didLoadData(with: $0)
                }, onError: { [weak self] in
					self?.output?.didFailLoadData(with: $0)
            })
            .disposed(by: bag)
    }

}
