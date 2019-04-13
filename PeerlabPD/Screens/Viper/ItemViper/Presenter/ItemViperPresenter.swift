//
//  ItemViperPresenter.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

protocol IItemViperModuleInput {

}

class ItemViperPresenter: IItemViperModuleInput, IItemViperViewOutput, IItemViperInteractorOutput {

    weak var view: IItemViperViewInput?
    let interactor: IItemViperInteractorInput
    let router: IItemViperRouterInput
    var item: IRepository

    init(with interactor: IItemViperInteractorInput, router: IItemViperRouterInput, repository: IRepository) {
        self.interactor = interactor
        self.router = router
        self.item = repository

        interactor.configure(with: self)
    }

    func configure(with view: IItemViperViewInput) {
        self.view = view
        view.config(with: self)
    }

    func viewIsReady() {
        let props = ItemViperViewController.ItemViperViewControllerProps(
            avatarImage: item.avatarUrl,
            name: item.name,
            descr: item.repoDescription
        )
		self.view?.refreshUI(with: props)
    }

}
