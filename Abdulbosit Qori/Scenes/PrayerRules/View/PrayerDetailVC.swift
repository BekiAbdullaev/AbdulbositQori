//
//  PrayerDetailVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary
import AVFoundation

class PrayerDetailVC: UIViewController, ViewSpecificController {
    // MARK: - RootView
    typealias RootView = PrayerDetailRootView
    var prayerTitle: String = ""
    var section: Int = -1
    var row: Int = -1
    var isManRule: Bool = false
    private var audioURL = ""
    var player: AVAudioPlayer?
    var selectedIndex = -1
    var isPlaying = false
    
    private var sliderTimer: Timer?
 
    override func loadView() {
        super.loadView()
        self.view = PrayerDetailRootView()
        self.view().section = section
        self.view().row = row
        self.view().isManRule = isManRule
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (isManRule ? PrayerRuleModel().prayerMenTypes[section] : PrayerRuleModel().prayerWomenTypes[section] ) + " - " + self.prayerTitle
        self.view().itemOnClick = { [weak self] index in
            guard let self = self else { return }
            let popUp = PopUpView()
            switch (self.section, self.row) {
            case (0,0):
                popUp.title =  PrayerRuleModel().bomdod2RakatSunnat[index].title
                popUp.subtitle = PrayerRuleModel().bomdod2RakatSunnat[index].detail
            case (0,1):
                popUp.title =  PrayerRuleModel().bomdod2RakatFarz[index].title
                popUp.subtitle = PrayerRuleModel().bomdod2RakatFarz[index].detail
            case (1,0):
                popUp.title =  PrayerRuleModel().peshin4RakatSunnat[index].title
                popUp.subtitle = PrayerRuleModel().peshin4RakatSunnat[index].detail
            case (1,1):
                popUp.title =  PrayerRuleModel().peshin4RakatFarz[index].title
                popUp.subtitle = PrayerRuleModel().peshin4RakatFarz[index].detail
            case (1,2):
                popUp.title =  PrayerRuleModel().peshin2RakatSunnat[index].title
                popUp.subtitle = PrayerRuleModel().peshin2RakatSunnat[index].detail
            case (2,0):
                popUp.title =  PrayerRuleModel().asr4RakatFarz[index].title
                popUp.subtitle = PrayerRuleModel().asr4RakatFarz[index].detail
            case (3,0):
                popUp.title =  PrayerRuleModel().shom3RakatFarz[index].title
                popUp.subtitle = PrayerRuleModel().shom3RakatFarz[index].detail
            case (3,1):
                popUp.title =  PrayerRuleModel().shom2RakatSunnat[index].title
                popUp.subtitle = PrayerRuleModel().shom2RakatSunnat[index].detail
            case (4,0):
                popUp.title =  PrayerRuleModel().xufton4RakatFarz[index].title
                popUp.subtitle = PrayerRuleModel().xufton4RakatFarz[index].detail
            case (4,1):
                popUp.title =  PrayerRuleModel().xufton2RakatSunnat[index].title
                popUp.subtitle = PrayerRuleModel().xufton2RakatSunnat[index].detail
            case (4,2):
                popUp.title =  PrayerRuleModel().xufton3RakatVitr[index].title
                popUp.subtitle = PrayerRuleModel().xufton3RakatVitr[index].detail
            case (5,0):
                popUp.title =  PrayerRuleModel().juma4RakatSunnat[index].title
                popUp.subtitle = PrayerRuleModel().juma4RakatSunnat[index].detail
            case (5,1):
                popUp.title =  PrayerRuleModel().juma2RakatFarz[index].title
                popUp.subtitle = PrayerRuleModel().juma2RakatFarz[index].detail
            case (5,2):
                popUp.title =  PrayerRuleModel().juma4RakatSunnat[index].title
                popUp.subtitle = PrayerRuleModel().juma4RakatSunnat[index].detail
            case (6,0):
                popUp.title =  PrayerRuleModel().janozaNomozi[index].title
                popUp.subtitle = PrayerRuleModel().janozaNomozi[index].detail
            default:
                break
            }
            self.view.addSubview(popUp)
        }
        
        
        self.view().audioOnClick = { [weak self] index, audioKey in
            guard let self = self else { return }
            
            if self.selectedIndex == index {
                if self.isPlaying {
                    self.player?.pause()
                    self.isPlaying = false
                } else {
                    self.player?.play()
                    self.isPlaying = true
                }
            } else {
                if self.isPlaying {
                    self.isPlaying = false
                    self.view().isPlay = false
                    MainBean.shared.currentAudioValue = PrayerAudioModel(value: 0.0, index: self.selectedIndex)
                    self.view().tableView.reloadRows(at: [IndexPath(row: self.selectedIndex, section: 0)], with: .none)
                }
                self.selectedIndex = index
                self.player?.stop()
                self.playAudio(index: index, fileURL: audioKey)
            }
            self.view().tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
        
        sliderTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.stop()
        player = nil
    }
    
    deinit {
        sliderTimer?.invalidate()
        sliderTimer = nil
        player?.stop()
        player = nil
    }
    
    @objc func updateSlider() {
        guard let player = player, selectedIndex >= 0 else { return }
        MainBean.shared.currentAudioValue = PrayerAudioModel(value: Float(player.currentTime), index: self.selectedIndex)
        self.view().tableView.reloadRows(at: [IndexPath(row: self.selectedIndex, section: 0)], with: .none)
    }
    
    func playAudio(index: Int, fileURL: String) {
        guard let url = Bundle.main.url(forResource: fileURL, withExtension: "mp3") else {
            print("Audio fayl topilmadi: \(fileURL)")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            self.isPlaying = true
            self.view().isPlay = true
            MainBean.shared.maxAudioValue = PrayerAudioModel(value: Float(player?.duration ?? 0), index: self.selectedIndex)
        } catch {
            print("Audio ijro etishda xatolik: \(error.localizedDescription)")
            player = nil
            self.isPlaying = false
            self.view().isPlay = false
        }
    }
}

extension PrayerDetailVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.view().isPlay = false
        MainBean.shared.currentAudioValue = PrayerAudioModel(value: 0.0, index: self.selectedIndex)
        if selectedIndex >= 0 {
            self.view().tableView.reloadRows(at: [IndexPath(row: self.selectedIndex, section: 0)], with: .none)
        }
    }
}

