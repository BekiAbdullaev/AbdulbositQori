//
//  BaseService.swift
//  AABNetworkRxSwift
//
//  Created by 1 on 8/30/20.
//  Copyright © 2020 loremispum. All rights reserved.
//

import Foundation
import Moya

public protocol BaseService:TargetType, AccessTokenAuthorizable{}
extension BaseService {
    public var environmentBaseURL:String {
        switch NetworkConfig().baseURL {
        case .production:
            return "http://194.135.85.227:9090/api"
        case .debug:
            return "debug api"
        case .custom:
            return "custom api"
        }
    }
    public var baseURL: URL {
        guard let url = URL(string:environmentBaseURL) else { fatalError("Base url could not be configured") }
        return url
    }
    public var headers: [String: String]? {
       // return ["Content-type": "application/json"]
        return [:]
    }
    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}
