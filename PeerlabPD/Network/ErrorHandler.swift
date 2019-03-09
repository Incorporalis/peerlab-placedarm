//
//  ErrorHandler.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation
import Alamofire

public enum ErrorDomains: String {
    case networkDomain = "PeerlabPD.network"
    case searchDomain = "PeerlabPD.search"
}

public enum ResponseStatus: String, Codable {
    case success
    case error
}

public enum NetworkErrors: Error {
    case unknownError(description: String, code: Int)
    case noData
    case badData
    case badInput
}

extension NetworkErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .unknownError(let description, _):
            return description
        case .badInput:
            return NSLocalizedString("Bad data input", comment: "")
        case .badData:
            return NSLocalizedString("Bad data format", comment: "")
        case .noData:
            return NSLocalizedString("Data should be provided", comment: "")
        }
    }
    
}

public enum DomainErrors: Error {
    case unknownError(description: String)
}

extension DomainErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .unknownError(let description):
            return description
        }
    }
    
}

public protocol INetworkErrorHandler {
    
    func handle(result: Result<Any>, with statusCode: Int?) -> Result<Any>
    func handle(error: Error, with completion:((NSError)->())?)
    
}

class NetworkErrorHandler : INetworkErrorHandler {
    
    func handle(error: Error, with completion: ((NSError) -> ())?) {
        if let networkError = error as? NetworkErrors {
            handle(error: networkError, with: completion)
        }
        
        let error = NSError(domain: ErrorDomains.networkDomain.rawValue, code: -1, userInfo: nil)
        completion?(error)
    }
    
    func unknownError() -> Error {
        return DomainErrors.unknownError(description: "An unknown error has occurred. Please try again.")
    }
    
    func handle(result: Result<Any>, with statusCode: Int?) -> Result<Any> {
        switch result {
        case .success(let data):
            guard let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) else {
                return Result.failure(unknownError())
            }
            
            guard let error = try? JSONDecoder().decode(ProjectError.self, from: jsonData) else {
                return Result.failure(unknownError())
            }
            
            guard let status = error.status else{
                return result
            }
            
            
            switch status {
            case .success:
                return result
            case .error:
                return Result.failure(NetworkErrors.unknownError(description: error.message ?? "No error message", code: statusCode ?? -1))
            }
        case .failure(let error):
            if let afError = error as? AFError {
                switch (afError) {
                case .responseSerializationFailed:
                    return Result.failure(unknownError())
                default:
                    break;
                }
            }
            return result
        }
    }
    
    func handle(error: NetworkErrors, with completion:((NSError) -> ())?) {
        let error = NSError(domain: ErrorDomains.networkDomain.rawValue, code: -1, userInfo: [NSLocalizedDescriptionKey:error.localizedDescription])
        completion?(error)
    }
    
}

class ProjectError: Codable {
    
    enum CodingKeys : String, CodingKey {
        case status
        case message
        case code
    }
    
    let status: ResponseStatus?
    let message: String?
    let code: Int?
    
}
