//
//  Store.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

class Store {
    private var state = State.initial
	private let queue = DispatchQueue.init(label: "myStoreQueue")

    func dispatch(_ action: Action) {
        queue.async {
            self.state = reduce(state: self.state, action: action)
            self.observers.forEach {
                $0.handle(self.state)
            }
        }
    }

    private class Observer: Hashable, Equatable {
        static func == (lhs: Store.Observer, rhs: Store.Observer) -> Bool {
            return lhs === rhs
        }

        let handle: (State) -> ()
        init(handle: @escaping (State) -> ()) {
            self.handle = handle
        }

        var hashValue: Int {
            return ObjectIdentifier(self).hashValue
        }
    }

    private var observers = Set<Observer>()

    func addObserver(_ observer: @escaping (State)->()) {
        queue.async {
        	self.observers.insert(Observer(handle: observer))
            observer(self.state)
        }
    }
}
