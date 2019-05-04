//
//  Repository.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import CoreData

protocol IRepository {

    var identifier: Int64? { get }
    var name: String? { get }
    var repoDescription: String? { get }
    var avatarUrl: URL? { get }

}

struct Repository: IRepository, Codable {

    var identifier: Int64?
    var name: String?
    var repoDescription: String?
    var avatarUrl: URL? {
        return owner?.avatarUrl
    }

    private var owner: User?

    enum CodingKeys: String, CodingKey {

        case identifier = "id"
		case name
        case repoDescription = "description"
		case owner

    }

    func createEntity(in context: NSManagedObjectContext) -> RepositoryManaged? {
        guard let id = identifier else { return nil }
        let repositoryFetch: NSFetchRequest<RepositoryManaged> = RepositoryManaged.fetchRequest()
        repositoryFetch.predicate = NSPredicate(format: "id == %d", id)
        repositoryFetch.fetchBatchSize = 1
        repositoryFetch.fetchLimit = 1

        var repository: RepositoryManaged?
        do {
            repository = try context.fetch(repositoryFetch).first
        } catch {
            print(error)
        }

        if repository == nil {
            repository = RepositoryManaged(context: context)
        }

        repository?.id = identifier as NSNumber?
        repository?.repoDescription = repoDescription
        repository?.title = name

        repository?.owner = self.owner?.createEntity(in: context)

        return repository
    }

}

extension RepositoryManaged: IRepository {
    var identifier: Int64? {
        return id?.int64Value
    }

    var name: String? {
        return title
    }

    var avatarUrl: URL? {
        return owner?.avatarLink.flatMap { URL(string: $0) }
    }
}
