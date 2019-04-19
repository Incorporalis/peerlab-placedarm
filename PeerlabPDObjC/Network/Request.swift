//
//  Request.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

public enum DataType {
    case JSON
}

public enum HTTPMethodType: String {
    case get = "GET"
}

public protocol IRequest {

    var path: String { get }
    var method: HTTPMethodType { get }
    var parameters: [String:String] { get }
    var dataType: DataType { get }

}

protocol IServerResponseModel: Codable {

    associatedtype Output: Codable

    var data: Output { get }
    
}

