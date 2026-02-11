//
//  AboutVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit

class AboutVC: UIViewController,ViewSpecificController {
    // MARK: - RootView
    typealias RootView = AboutRootView
    weak var coordinator: MainCoordinator?
   
    override func loadView() {
        super.loadView()
        self.view = AboutRootView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Haqida"
        self.view().lblName.attributedText = String.setLineSpace(text: "Abdulbosit qori Qobilov", space: 5)
        self.view().lblShortDetail.attributedText = String.setLineSpace(text: AboutModel().title)
        self.view().lblDetail.attributedText = String.setLineSpace(text: AboutModel().detail)
        self.view().btnFacebook.addTarget(self, action: #selector(btnFacebookClicked), for: .touchUpInside)
        self.view().btnInstagram.addTarget(self, action: #selector(btnInstagramClicked), for: .touchUpInside)
        self.view().btnTelegram.addTarget(self, action: #selector(btnTelegramClicked), for: .touchUpInside)
        self.view().btnYoutube.addTarget(self, action: #selector(btnYoutubeClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func btnFacebookClicked() {
        self.openUrl(url: "https://www.facebook.com/Abdulbositqoriofficial")
    }
    
    @objc func btnInstagramClicked() {
        self.openUrl(url: "https://Instagram.com/abdulbositqoriuz")
    }
    
    @objc func btnTelegramClicked() {
        self.openUrl(url: "https://t.me/abdulbositqoriuz")
    }
    
    @objc func btnYoutubeClicked() {
        self.openUrl(url: "https://www.youtube.com/@abdulbositqoriuz")
    }
    
    func openUrl(url:String) {
        let url = URL(string:url)
        if UIApplication.shared.canOpenURL(url!) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:]) { (success) in
                    if success {}
                }
            } else {
                UIApplication.shared.openURL(url!)
            }
        }
    }
}
