//
//  User.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation

protocol IUser {

    var avatarUrl: URL? { get }

}

struct User: IUser, Codable {

    var avatarUrl: URL?

    enum CodingKeys: String, CodingKey {
		case avatarUrl = "avatar_url"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: User.CodingKeys.self)
        let urlStr = try map.decode(String.self, forKey: .avatarUrl)
		avatarUrl = URL(string: urlStr)
    }

}
