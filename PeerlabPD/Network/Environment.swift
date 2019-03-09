//
//  Environment.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation

enum EnvironmentType : String, Decodable {
    case PROD
    
    func host() -> String {
        switch self {
        case .PROD:
            return "https://api.github.com"
        }
    }
}

protocol IEnvironment {
    
    var type: EnvironmentType { get }
    var host: String { get }
    var contentType: String { get }
    var headers: [String: Any] { get set }
    var cachePolicy: URLRequest.CachePolicy { get set }

}

struct Environment: IEnvironment {

    var headers: [String: Any] = [:]
    var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    let type: EnvironmentType
    let contentType: String = "application/json"
    
    var host: String {
        return type.host()
    }
    
    public init(_ type: EnvironmentType) {
        self.type = type
    }

}
