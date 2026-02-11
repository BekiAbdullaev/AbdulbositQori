//
//  QuranStudyVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary

class QuranStudyVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = QuranStudyRootView
    weak var coordinator: MainCoordinator?
    
    // MARK: - Lifecycle
    override func loadView() {
        let rootView = QuranStudyRootView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgMain")
        self.appearanceSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.view().player.pause()
    }
    
    private func appearanceSettings() {
        self.navigationItem.title = "Quron ta'limi"
    }
}
