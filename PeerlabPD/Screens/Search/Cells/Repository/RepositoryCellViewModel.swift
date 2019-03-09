//
//  RepositoryCellViewModel.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation
import UIKit

protocol IRepositoryCellViewModel {

    var name: String { get }
    var repoDescription: String { get }
    var userAvatar: URL? { get }
    var placeholder: UIImage { get }

}

class RepositoryCellViewModel: IRepositoryCellViewModel {

    var name: String
    var repoDescription: String
    var userAvatar: URL?
    var placeholder: UIImage

    init(with repository: IRepository) {

		name = repository.name ?? "<no name>"
        repoDescription = repository.repoDescription ?? "<no description>"
        userAvatar = repository.avatarUrl
        placeholder = #imageLiteral(resourceName: "profile_placeholder")

    }

}
