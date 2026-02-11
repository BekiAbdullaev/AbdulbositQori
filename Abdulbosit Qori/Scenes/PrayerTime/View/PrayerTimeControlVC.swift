//
//  PrayerTimeControlVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/11/23.
//

import Foundation
import UIKit
import MyLibrary
import AVFoundation

protocol PrayerTimeControlIxResponder:AnyObject {
    func prayerSoundChanged(state:PrayerTimeState)
}

class PrayerTimeControlVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = PrayerTimeControlRootView
    weak var coordinator: MainCoordinator?
    weak var delegate:PrayerTimeControlIxResponder?
    private var state:PrayerTimeState?
    private var isSun:Bool?
    var player:AVAudioPlayer?
    
    // MARK: - Lifecycle
    init(state:PrayerTimeState,vc:UIViewController, isSun:Bool) {
        self.state = state
        self.isSun = isSun
        self.delegate = vc as? any PrayerTimeControlIxResponder
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func loadView() {
        let rootView = PrayerTimeControlRootView()
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgMain")
        self.appearanceSettings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let player = player {
            player.stop()
        }
    }

    private func appearanceSettings() {
        self.navigationItem.title = "Namoz vaqtini eslatish"
        self.view().OnClick = { state in
            self.delegate?.prayerSoundChanged(state: state)
        }
        self.view().azonClicked = {
            if self.view().isPlaying {
                self.playAzon()
            } else {
                self.stopAzon()
            }
        }
        if isSun ?? false {
            self.view().numberOfState = PrayerTimeModel().prayerSoundsList.count-1
        }
    }
    
    func playAzon(){
        let url = Bundle.main.url(forResource: "AZON", withExtension: "mp3")
        do {
            player = try! AVAudioPlayer(contentsOf: url!)
            player?.play()
        }
    }
    func stopAzon(){
        if let player = player {
            player.stop()
        }
    }
}

