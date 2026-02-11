//
//  LaunchScreen.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import Foundation
import UIKit
import LocalAuthentication

class LaunchScreen: UIViewController{
    private var coordinator: MainCoordinator?

    override func viewDidLoad() {
        view = LaunchRootView()
        guard let navigationController = navigationController else { return }
        navigationController.setNavigationBarHidden(true, animated: false)
        coordinator = MainCoordinator(navigationController: navigationController)
        start()
    }
    func start(){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
            self.coordinator?.start()
        }
    }
    func dismissedViewController() {
        start()
    }
}
