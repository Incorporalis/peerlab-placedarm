//
//  ItemViperAssembly.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

protocol IItemViperAssembly {

 	func createModule(with view: IItemViperViewInput, dependencies: RouterDependencies)
    
}

class ItemViperAssembly {

    func createModule(with view: IItemViperViewInput, dependencies: RouterDependencies, repository: IRepository) {
        let interactor = ItemViperInteractor()
        let router = ItemViperRouterInput()
        let presenter = ItemViperPresenter(with: interactor, router: router, repository: repository)
        presenter.configure(with: view)
    }

}
