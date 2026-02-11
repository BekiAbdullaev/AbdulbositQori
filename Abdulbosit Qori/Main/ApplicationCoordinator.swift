//
//  ApplicationCoordinator.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import Foundation
import UIKit

class ApplicationCoordinator: Coordinator {
    private let window: UIWindow
    var navigationController: UINavigationController
    
    init(window: UIWindow) {
        self.window = window
        navigationController = DefaultNavigationController(rootViewController: LaunchScreen())
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
