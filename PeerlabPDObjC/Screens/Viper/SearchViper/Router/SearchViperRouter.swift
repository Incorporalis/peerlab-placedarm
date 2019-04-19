//
//  SearchViperRouter.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import UIKit

protocol ISearchViperRouterInput {

    func showDetails(for model:IRepository)

}

class SearchViperRouter: ISearchViperRouterInput {

    enum SearchViperRoutes: String {
        case itemViewController = "ItemViperViewController"
    }

    let dependencies: RouterDependencies
    let view: ISearchViperViewInput

    init(with dependencies: RouterDependencies, view: ISearchViperViewInput) {
		self.dependencies = dependencies
        self.view = view
    }

    func showDetails(for model:IRepository) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewController = sb.instantiateViewController(withIdentifier: SearchViperRoutes.itemViewController.rawValue) as! ItemViperViewController
        ItemViperAssembly().createModule(with: viewController, dependencies: dependencies, repository: model)
		view.navigationController?.pushViewController(viewController, animated: true)
    }

}
