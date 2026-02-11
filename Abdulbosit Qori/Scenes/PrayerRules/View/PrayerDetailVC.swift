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

class PrayerDetailVC: UIViewController,ViewSpecificController {
    // MARK: - RootView
    typealias RootView = PrayerDetailRootView
    var tittle:String = ""
    var section:Int = -1
    var row:Int = -1
    var isManRule:Bool = false
    private var audioURL = ""
    var player:AVAudioPlayer?
    var selectedIndex = -1
    var isPlaying = false
    
    private var timer:Timer?
 
    override func loadView() {
        super.loadView()
        self.view = PrayerDetailRootView()
        self.view().section = section
        self.view().row = row
        self.view().isManRule = isManRule
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = (isManRule ? PrayerRuleModel().prayerMenTypes[section] : PrayerRuleModel().prayerWomenTypes[section] ) + " - " + self.tittle
        self.view().itemOnClick = { index in
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
            case (_, _):
                print("")
            }
            self.view.addSubview(popUp)
        }
        
        
        self.view().audioOnClick = { index, audioKey in
            
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
//                for item in MainBean.shared.namazs {
//                    if audioKey == item.key {
//                        self.playAudio(index: index, fileURL: item.file_url ?? "")
//                    }
//                }
            }
            self.view().tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
        let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let player = player {
            player.stop()
        }
    }
    
    @objc func updateSlider() {
        if let player = player{
            MainBean.shared.currentAudioValue = PrayerAudioModel(value:Float(player.currentTime), index: self.selectedIndex)

            self.view().tableView.reloadRows(at: [IndexPath(row: self.selectedIndex, section: 0)], with: .none)
            
        }
    }
    
    func playAudio(index:Int, fileURL:String){
        
        let url = Bundle.main.url(forResource: fileURL, withExtension: "mp3")
        do {
            player = try! AVAudioPlayer(contentsOf: url!)
            player?.play()
            self.player?.delegate = self
            self.isPlaying = true
            self.view().isPlay = true
            MainBean.shared.maxAudioValue = PrayerAudioModel(value: Float(player?.duration ?? 0), index: self.selectedIndex)
        }
        
        
//        if checkIsDownloaded(index: index, fileURL: fileURL) {
//
//            guard let desURL = URL(string: audioURL) else {return}
//            do {
//                player = try AVAudioPlayer(contentsOf: desURL)
//                player?.prepareToPlay()
//                player?.delegate = self
//                player?.play()
//                self.isPlaying = true
//                self.view().isPlay = true
//                MainBean.shared.maxAudioValue = PrayerAudioModel(value: Float(player?.duration ?? 0), index: self.selectedIndex)
//            } catch _ {
//                player = nil
//            }
//        } else {
//            downloadFileAtIndex(index: index, fileURL: fileURL)
//        }
    }
    
//    func checkIsDownloaded(index:Int, fileURL:String)->Bool {
//        var downloaded = false
//        if let audioUrl = URL(string: fileURL) {
//            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//            audioURL = destinationUrl.absoluteString
//            if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                downloaded = true
//            }
//        }
//        return downloaded
//    }
//
//    func downloadFileAtIndex(index:Int, fileURL:String){
//
//        if let audioUrl = URL(string: fileURL) {
//            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
//            print(destinationUrl)
//            if FileManager.default.fileExists(atPath: destinationUrl.path) {
//                print("The file already exists at path")
//            } else {
//                URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
//                    guard let location = location, error == nil else { return }
//                    do {
//                        try FileManager.default.moveItem(at: location, to: destinationUrl)
//                        print("File moved to documents folder")
//                        self.playAudio(index: index, fileURL: fileURL)
//                    } catch {
//                        print(error)
//                    }
//                }.resume()
//            }
//        }
//    }
}

extension PrayerDetailVC:AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        self.isPlaying = false
        self.view().isPlay = false
        MainBean.shared.currentAudioValue = PrayerAudioModel(value: 0.0, index: self.selectedIndex)
        self.view().tableView.reloadRows(at: [IndexPath(row: self.selectedIndex, section: 0)], with: .none)
    }
}
