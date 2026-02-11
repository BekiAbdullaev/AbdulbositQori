//
//  MainCoordinator.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import Foundation
import UIKit
import MyLibrary
import AVFoundation

final class MainCoordinator: Coordinator {
    internal var navigationController: UINavigationController
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    internal func start() {
        let viewcontroller = MainVC()
        viewcontroller.coordinator = self
        navigationController.pushViewController(viewcontroller, animated: true)
    }
    
    func pushToQibla() {
        let vc = QiblaVC()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToBribes() {
        let vc = QuranBribesVC()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushPrayerRuleType(isManRule:Bool) {
        let vc = PrayerRuleTypeVC()
        vc.coordinator = self
        vc.isManRule = isManRule
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToStydy() {
        let vc = QuranStudyVC()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToPrayerRule() {
        let vc = PrayerRulesVC()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushPrayerDetail(title:String, section:Int, row:Int ,isManRule:Bool){
        let vc = PrayerDetailVC()
        vc.tittle = title
        vc.section = section
        vc.row = row
        vc.isManRule = isManRule
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushAbout(){
        let vc = AboutVC()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    func pushToPrayerTime(){
        let vc = PrayerTimeVC()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
    func pushToRosary(){
        let vc = RosaryVC()
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }

    func pushToPlayerTimeControl(state:PrayerTimeState, vc:UIViewController, isSun:Bool){
        let vc = PrayerTimeControlVC(state: state, vc: vc, isSun: isSun)
        vc.coordinator = self
        self.navigationController.pushViewController(vc, animated: true)
    }
    
}

