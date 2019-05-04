//
//  Fetch.swift
//  PeerlabPD
//
//  Created by Ivan on 04/05/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import CoreData

extension NSManagedObject {

    class func fetch<T:NSFetchRequestResult>() -> NSFetchRequest<T> {
        let fetch = NSFetchRequest<T>(entityName: NSStringFromClass(T.self))
        return fetch
    }

}
