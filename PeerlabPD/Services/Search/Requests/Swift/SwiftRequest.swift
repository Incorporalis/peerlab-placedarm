//
//  SwiftRequest.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation

class SwiftRequestOpeation: IRequestOperation {

    typealias ResponseModel = SwiftRequestResponseModel

    var request: IRequest {
        return SwiftRequest()
    }

    struct SwiftRequestResponseModel: IServerResponseModel {

        typealias Output = [Repository]

        enum CodingKeys: String, CodingKey {
            case data = "items"
        }

        var data: [Repository]

    }

}

class SwiftRequest: IRequest {

    var path: String {
        return "search/repositories"
    }

    var dataType: DataType {
        return .JSON
    }

    var method: HTTPMethodType {
        return .get
    }

    var parameters: [String : String] {
        return ["q" : "swift"]
    }

}
