//
//  Plugins.swift
//  AABNetworkRxSwift
//
//  Created by 1 on 8/27/20.
//  Copyright © 2020 loremispum. All rights reserved.
//

import Foundation
import Moya
import MBProgressHUD

public final class RequestLoadingPlugin: PluginType {
    //public let defaultHud = HudMaker().makeHud(type: .customHud)
    
    public func willSend(_ request: RequestType, target: TargetType) {
        // show loading
//        DispatchQueue.main.async {
//            self.showDefaultHud(view: nil, hud: self.defaultHud)
//        }
    }
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        // hide loading
//        DispatchQueue.main.async {
//            self.hideDefaultHud(hud: self.defaultHud)
//        }
    }
}
