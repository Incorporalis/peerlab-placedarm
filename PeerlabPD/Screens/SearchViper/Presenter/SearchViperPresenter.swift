//
//  SearchViperPresenter.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

protocol ISearchViperModuleInput {
	
}

class SearchViperPresenter: ISearchViperModuleInput, ISearchViperViewOutput, ISearchViperInteractorOutput {

    weak var view: ISearchViperViewInput?
    let interactor: ISearchViperInteractorInput
    let router: ISearchViperRouterInput
    var elements = [IRepositoryCellViewModel]()


    init(with interactor: ISearchViperInteractorInput, router: ISearchViperRouterInput) {
        self.interactor = interactor
        self.router = router

        interactor.configure(with: self)
    }

    func configure(with view: ISearchViperViewInput) {
        self.view = view
        view.config(with: self)
    }

    func viewIsReady() {
        loadRequest()
    }

    private func loadRequest() {
        view?.showHUD()

        loadData()
    }

    func refreshData() {
        loadData()
    }

    func loadData() {
        interactor.startDataLoading()
    }

    func didLoadData(with repositories:[IRepository]?) {
        if let reps = repositories {
            elements = reps.map { RepositoryCellViewModel(with: $0) }
            view?.hideHUD()
            view?.refreshUI()
        }
    }

    func didFailLoadData(with error: Error) {
        self.view?.showFailureRequestAlert(with: error.localizedDescription, actionHandler:{ [weak self] in
            self?.interactor.startDataLoading()
            }, completion: { [weak self] in
                self?.view?.hideHUD()
        })
    }

    func viewDidPressDetailsButton(with index: Int) {
        let models: [Any] = [index]
		router.showDetails(for: models[index])
    }

}
