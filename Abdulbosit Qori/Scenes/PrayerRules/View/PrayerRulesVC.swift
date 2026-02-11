//
//  PrayerRulesVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary

class PrayerRulesVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = PrayerRulesRootView
    weak var coordinator: MainCoordinator?
    var genderType:PrayerGenderType?
    
    // MARK: - Lifecycle
    override func loadView() {
        let rootView = PrayerRulesRootView()
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
    
    private func appearanceSettings() {
        self.navigationItem.title = "Namoz o'qish tartibi"
        self.view().itemOnClick = { index in
            self.coordinator?.pushPrayerRuleType(isManRule: index == 0 ? true : false)
        }
    }
}
extension PrayerRulesVC:IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        var title = ""
        switch genderType {
        case .men:
            title = "Erkaklar"
        case .women:
            title = "Ayollar"
        default:
            title = ""
            
        }
        return IndicatorInfo(title: title)
    }
}
