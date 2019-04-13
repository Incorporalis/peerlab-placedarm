//
//  SearchViperAssembly.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

protocol ISearchViperAssembly {

 	func createModule(with view: ISearchViperViewInput, dependencies: RouterDependencies)
    
}

class SearchViperAssembly {

    func createModule(with view: ISearchViperViewInput, dependencies: RouterDependencies) {
        let interactor = SearchViperInteractor(with: dependencies.searchService)
        let router = SearchViperRouter(with: dependencies, view: view)
		let presenter = SearchViperPresenter(with: interactor, router: router)
        presenter.configure(with: view)
    }

}
