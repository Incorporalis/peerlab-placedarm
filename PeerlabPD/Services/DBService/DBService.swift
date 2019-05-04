//
//  DBService.swift
//  PeerlabPD
//
//  Created by Ivan on 04/05/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import CoreData

protocol IDBService {
    var context: NSManagedObjectContext { get }
	func save()
}

class DBService: IDBService {

    var persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }

    init(with container: NSPersistentContainer) {
        persistentContainer = container

        container.loadPersistentStores { (desc, err) in
            if let error = err {
                print(error)
                fatalError()
            }
        }
    }

    func save() {
        if context.hasChanges {
            context.performAndWait { [weak self] in
                do {
                    try self?.context.save()
                } catch {
                    print(error)
                    fatalError()
                }
            }
        }
    }

}
