//
//  PrayerRulePagerVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary

class PrayerRuleTypeVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = PrayerRuleTypeView
    weak var coordinator: MainCoordinator?
    var isManRule = false
    
    // MARK: - Lifecycle
    override func loadView() {
        let rootView = PrayerRuleTypeView()
        rootView.isManRule = isManRule
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
        self.view().itemOnClick = { section, row, title in
            self.coordinator?.pushPrayerDetail(title: title, section: section, row: row, isManRule: self.isManRule)
        }
        self.getNamazs { response in
            MainBean.shared.namazs = response.namaz_files
        }
    }
}

// MARK: Network
extension PrayerRuleTypeVC {
    private func getNamazs(success:((NamazsResponse) -> Void)?) {
        NetworkManager(.noHud).request(MainService.getNamazs) { result in
            BaseNetwork().processResponse(result: result, success: success) { error in
                print("Error: \(error?.message ?? "oшибка")")
                // self.showBaseErrorAlert(subtitle: error?.message ?? "oшибка")
            }
        }
    }
}


    
