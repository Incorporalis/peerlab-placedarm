//
//  Repository.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation

protocol IRepository: Codable {

    var name: String? { get }
    var repoDescription: String? { get }
    var avatarUrl: URL? { get }

}

struct Repository: IRepository {

    var name: String?
    var repoDescription: String?
    var avatarUrl: URL? {
        return owner?.avatarUrl
    }

    private var owner: User?

    enum CodingKeys: String, CodingKey {

		case name
        case repoDescription = "description"
		case owner

    }

}
