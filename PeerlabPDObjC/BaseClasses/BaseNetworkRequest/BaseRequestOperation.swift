//
//  BaseRequestOperation.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol IRequestOperation {
    associatedtype ResponseModel: IServerResponseModel
    
    var request: IRequest { get }
    func execute(in dispatcher: INetworkDispatcher, with completion: @escaping (Result<ResponseModel.Output>)->Void) throws
}

extension IRequestOperation {
 
    func execute(in dispatcher: INetworkDispatcher, with completion: @escaping (Result<ResponseModel.Output>)->Void) throws {
        try dispatcher.execute(request: self.request) { (response) in
            let checkedResult = dispatcher.errorHandler.handle(result: response.result, with: response.response?.statusCode)
            
            switch(checkedResult) {
            case .success(let data):
                
                guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
                    completion(Result.failure(DomainErrors.unknownError(description: "Bad response, unhadled error")))
                    return
                }
                
                do {
                    let responseModel = try JSONDecoder().decode(ResponseModel.self, from: jsonData)
                    completion(Result.success(responseModel.data))
                } catch {
                    completion(Result.failure(DomainErrors.unknownError(description: "Bad response format, unhadled error")))
                    return
                }
                
            case .failure(let error):
                completion(Result.failure(error))
                break
            }
        }
    }
    
}
