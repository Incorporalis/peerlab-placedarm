//
//  NetworkDispatcher.swift
//  PeerlabPD
//
//  Created by Ivan.Kramarenko on 11.09.2018.
//  Copyright © 2018 IvanKram. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

protocol INetworkDispatcher{
    
    var errorHandler: INetworkErrorHandler { get }
    func execute(request: IRequest, completion: @escaping (DataResponse<Any>)->()) throws
    
}

class NetworkDispatcher: INetworkDispatcher {
    
    public let errorHandler: INetworkErrorHandler
    private var environment: IEnvironment
    
    required init(environment: IEnvironment, errorHandler: INetworkErrorHandler) {
        self.environment = environment
        self.errorHandler = errorHandler
    }
    
    public func execute(request: IRequest, completion: @escaping (DataResponse<Any>)->()) throws {
        let rq = try self.prepareURLRequest(for: request)
        runInBackground({
            let taskId = $0
            print("sending request with url: \(rq.url?.absoluteString ?? "(none)")")
            Alamofire.request(rq).responseJSON(completionHandler: {
                print("got response from request: \(rq.url?.absoluteString ?? "(none)")\nresponse:\n\n\($0 as AnyObject)")
                completion($0)
                UIApplication.shared.endBackgroundTask(taskId)
            })
        })
    }
    
    private func runInBackground(_ closure: @escaping (UIBackgroundTaskIdentifier) -> Void, expirationHandler: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            let taskID: UIBackgroundTaskIdentifier
            if let expirationHandler = expirationHandler {
                taskID = UIApplication.shared.beginBackgroundTask(expirationHandler: expirationHandler)
            } else {
                taskID = UIApplication.shared.beginBackgroundTask(expirationHandler: { })
            }
            closure(taskID)
        }
    }
    
    private func prepareURLRequest(for request: IRequest) throws -> URLRequest {
        let fullUrl = "\(environment.host)/\(request.path)"
        guard let url = URL(string: fullUrl) else {
            throw NetworkErrors.badInput
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("\(environment.contentType)", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("\(environment.contentType)", forHTTPHeaderField: "Accept")
        
        if (request.parameters.count > 0) {
            let params = request.parameters
            let queryParams = params.map({ (element) -> URLQueryItem in
                return URLQueryItem(name: element.key, value: element.value)
            })
            guard var components = URLComponents(string: fullUrl) else {
                throw NetworkErrors.badInput
            }
            components.queryItems = queryParams
            urlRequest.url = components.url
        }
        
        environment.headers.forEach { urlRequest.addValue($0.value as! String, forHTTPHeaderField: $0.key) }
        
        urlRequest.httpMethod = request.method.rawValue
        
        return urlRequest
    }
}
