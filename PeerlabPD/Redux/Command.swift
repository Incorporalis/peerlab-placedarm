//
//  Command.swift
//  PeerlabPD
//
//  Created by Ivan on 09/03/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation

class Command {
    private let action: ()->()

    static let nop = Command {}

    init(with action: @escaping ()->()) {
        self.action = action
    }

    func run() {
        action()
    }
}
