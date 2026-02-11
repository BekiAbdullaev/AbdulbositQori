//
//  BaseNetwork.swift
//  AABNetworkRxSwift
//
//  Created by 1 on 8/30/20.
//  Copyright © 2020 loremispum. All rights reserved.
//
import Foundation
import Moya
import UIKit

public typealias NetworkFailureBlock = ((ErrorModel?) -> ())

extension BaseNetwork{
    public struct NetworkConfiguration {
        // MARK: - Properties
        public var baseURL: APIBase
        
        public init(baseURL:APIBase){
            self.baseURL = baseURL
        }
    }
}

open class BaseNetwork {
    public var configuration: NetworkConfiguration
    
    //MARK: Set Base NetworkConfiguration
    public init(configuration: NetworkConfiguration = NetworkConfiguration(baseURL: APIBase.production)) {
        self.configuration = configuration
    }
    
    public func processResponse<T>(result: Result<Moya.Response, MoyaError>, success: ((T) -> ())?, failure: NetworkFailureBlock?) where T: Codable {
        switch result {
        case let .success(response):
            self.validate(response, success: { () in
                            do {
                                let data = try response.map(T.self)
                                success?(data)
                            }catch let error {
                                print("Cannot map \(error)")}},
                          error: { (error) in
                            failure?(error)
                          })
        case let .failure(error):
            print(error)
        }
    }
    public func processWithoutMapResponse(result: Result<Moya.Response,MoyaError>, success:(()->())?,failure:NetworkFailureBlock?){
        switch result {
        case let .success(response):
            self.validate(response) {
                success?()
            } error: { (error) in
                failure?(error)
            }
        case let .failure(error):
            print(error)
        }
    }
    
    public func validate(_ response: Response, success: @escaping (() -> ()), error: @escaping ((ErrorModel?) -> ())) {
        if (response.statusCode >= 200) && (response.statusCode < 300) {
            success()
        }
        //TODO: - Implement error cases
        else if ((response.statusCode == 400) || (response.statusCode == 403)) {
            print("error with \(response.statusCode)")
            var presentableError: ErrorModel? = nil
            do {
                let errorResponse = try response.map(DefaultError.self)
                presentableError = ErrorModel(message: errorResponse.message, code: "\(errorResponse.statusCode)")
            }
            catch {
                print(error)
            }
            error(presentableError)
        } else if (response.statusCode == 401) {
            // MARK: - Token expired case
            
            var presentableError: ErrorModel? = nil
            do {
                let errorResponse = try response.map(DefaultError.self)
                presentableError = ErrorModel(message: errorResponse.message, code: "\(errorResponse.statusCode)")
            
                NotificationCenter.default.post(  // This helps to show authorization alert
                  name: Notification.Name("CheckAuthorization"),
                  object: nil)
                
                if errorResponse.message == "Unauthorized" {
                   print("Unauthorized")
                }
            } catch {
                print("error with message: \(String(describing: presentableError?.message)) and status code:\(String(describing: presentableError?.code))")
            }
            print("error with \(response.statusCode)")
        }
        else {
            var presentableError: ErrorModel? = nil
            do {
                let errorResponse = try response.map(DefaultError.self)
                presentableError = ErrorModel(message: errorResponse.message, code: "\(errorResponse.statusCode)")
            } catch {
                print(error)
            }
            error(presentableError)
        }
    }
}
