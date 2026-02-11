//
//  APIConst.swift
//  AABNetworkRxSwift
//
//  Created by 1 on 8/28/20.
//  Copyright © 2020 loremispum. All rights reserved.
//

import Foundation

public enum APIBase {
    case debug
    case production
    case custom
    
    // MARK: Others
}

public struct NetworkConfig {
    public var baseURL: APIBase
    
    public init(baseURL:APIBase = .production) {
        self.baseURL = baseURL
    }

    public var environmentBaseURL:String {
        switch baseURL {
        case .production:
            return "http://194.135.85.227:9090/api"
        case .debug:
            return "debug api"
        case .custom:
            return "custom api"
        }
    }
}

//MARK: OTHER CONST APIS
public struct APIConst {
    public static let termsURL = ""
    public static let privacyURL = ""
}
