//
//  AppDelegate.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 10.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import UIKit
import CoreData

import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy private var dependencies: RouterDependencies = {
		return loadDependencies()
    }()

    let store = Store()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        dependencies.routerAssembly.assembleMainScreenAsRoot(with: dependencies)
//        startRedux()


        return true
    }

    func startRedux() {
        guard let vc = window?.rootViewController as? ReduxViewController else { fatalError() }
        let presenter = ReduxVCPresenter(render: { props in
            DispatchQueue.main.async {
                vc.props = props
            }
        }, dispatch: store.dispatch)

        store.addObserver(presenter.handle)

        let loader = RepositoriesLoadingController(
            service: loadDependencies().searchService,
            dispatch: store.dispatch
        )

        store.addObserver(loader.handle)
    }

    func loadDependencies() -> RouterDependencies {
        let env                = Environment(.PROD)
        let errorHandler       = NetworkErrorHandler()

        let networkDispatcher  = NetworkDispatcher(environment: env, errorHandler: errorHandler)

        let container          = NSPersistentContainer(name: "PeerlabPD")
        let dbService          = DBService(with: container)

        let searchService      = SearchService(with: networkDispatcher, dbService: dbService)

        let routerAssembly	   = RouterAssembly()

        return RouterDependencies(
            routerAssembly: routerAssembly,
            searchService: searchService,
            dbService: dbService
        )
    }

}

