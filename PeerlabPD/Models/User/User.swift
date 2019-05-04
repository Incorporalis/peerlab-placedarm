//
//  User.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation
import CoreData

protocol IUser {

    var avatarUrl: URL? { get }
    var name: String? { get }
    var identifier: Int64? { get }

}

struct User: IUser, Codable {

    var avatarUrl: URL?
    var name: String?
    var identifier: Int64?

    enum CodingKeys: String, CodingKey {
		case avatarUrl = "avatar_url"
		case name
        case identifier = "id"
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: User.CodingKeys.self)
        let urlStr = try map.decode(String.self, forKey: .avatarUrl)
        name = try map.decodeIfPresent(String.self, forKey: .name)
        identifier = try map.decodeIfPresent(Int64.self, forKey: .identifier)
		avatarUrl = URL(string: urlStr)
    }

    func createEntity(in context: NSManagedObjectContext) -> UserManaged? {
        guard let id = identifier else { return nil }
        let userFetch: NSFetchRequest<UserManaged> = UserManaged.fetchRequest()
        userFetch.predicate = NSPredicate(format: "id == %d", id)
		userFetch.fetchBatchSize = 1
        userFetch.fetchLimit = 1

        var user: UserManaged?
        do {
        	user = try context.fetch(userFetch).first
        } catch {
            print(error)
        }

        if user == nil {
            user = UserManaged(context: context)
        }

        user?.id = identifier as NSNumber?
        user?.avatarLink = avatarUrl?.absoluteString
        user?.name = name

        return user
    }

}


extension UserManaged: IUser {

    var identifier: Int64? {
        return id?.int64Value
    }

    var avatarUrl: URL? {
        guard let link = avatarLink else { return nil }
        return URL(string: link)
    }
}
