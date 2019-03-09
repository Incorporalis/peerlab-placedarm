//
//  RepositoriesViewModel.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation
import RxSwift

protocol IRepositoriesViewModel {

    var elements: [RepositoryCellViewModel] {get}

	func viewIsReady()
    func refreshData()

}

protocol RepositoriesViewModelDelegate: class, ShowActivityController, ShowAlertController {

    func refreshUI()

}

class RepositoriesViewModel: IRepositoriesViewModel {

	private let searchService: ISearchService
    private let bag = DisposeBag()
    private weak var delegate: RepositoriesViewModelDelegate?

    init(with searchService: ISearchService) {
		self.searchService = searchService
    }

    func config(with delegate: RepositoriesViewModelDelegate) {
        self.delegate = delegate
    }

    var elements = [RepositoryCellViewModel]()
    var repositories: [IRepository]? {
        didSet {
            if let reps = repositories {
            	elements = reps.map { RepositoryCellViewModel(with: $0) }
            }
        }
    }

    func viewIsReady() {
        loadRequest()
    }

    func loadRequest() {
        delegate?.showHUD()

        loadData()
    }

    func refreshData() {
		loadData()
    }

    private func loadData() {
        searchService.getRepositoriesSignal
            .subscribe(onNext: { [weak self] in
                self?.repositories = $0

                self?.delegate?.refreshUI()
                self?.delegate?.hideHUD()
                }, onError: { [weak self] in
                    self?.delegate?.showFailureRequestAlert(with: $0.localizedDescription, actionHandler:{ [weak self] in
                        self?.loadRequest()
                        }, completion: { [weak self] in
                            self?.delegate?.hideHUD()
                    })
            })
            .disposed(by: bag)
    }

}
