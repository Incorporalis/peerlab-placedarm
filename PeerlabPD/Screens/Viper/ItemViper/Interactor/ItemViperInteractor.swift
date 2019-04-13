//
//  ItemViperInteractor.swift
//  PeerlabPD
//
//  Created by Ivan on 12/01/2019.
//  Copyright © 2019 IvanKram. All rights reserved.
//

import Foundation
import RxSwift

protocol IItemViperInteractorInput: class {

    func configure(with output: IItemViperInteractorOutput)

}

protocol IItemViperInteractorOutput: class {

}

class ItemViperInteractor: IItemViperInteractorInput {

    weak var output: IItemViperInteractorOutput?
    private let bag = DisposeBag()

    func configure(with output: IItemViperInteractorOutput) {
        self.output = output
    }

}
