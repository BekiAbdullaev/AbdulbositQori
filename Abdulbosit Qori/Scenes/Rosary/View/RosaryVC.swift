//
//  RosaryVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/5/23.
//

import Foundation
import UIKit
import MyLibrary
import AVFoundation

class RosaryVC:UIViewController,ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = RosaryRootView
    weak var coordinator: MainCoordinator?
    var partCounter = 0
    var counter = 0
    var totalCounter = 0
    var isInfinity:Bool = false
    var needVibration:Bool = true
    var userDefaults = UserDefaults.standard
    var player:AVAudioPlayer?
    var selectedIndex = -1
   
    var timer = Timer()
    var secondsLeft = 1
    var hoursLeft = 0
    var minutesLeft = 0
    
    // MARK: - Lifecycle
    override func loadView() {
        let rootView = RosaryRootView()
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
        if let player = player {
            player.stop()
        }
    }
    
    private func appearanceSettings() {
        self.navigationItem.title = "Tasbeh"
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(plusTaped(tapGestureRecognizer:)))
        self.view().delegate = self
        self.view().imgPlus.isUserInteractionEnabled = true
        self.view().imgPlus.addGestureRecognizer(tapGestureRecognizer)
        self.view().btnVoice.addTarget(self, action: #selector(btnVibrationClicked), for: .touchUpInside)
        self.view().btnInfinity.addTarget(self, action: #selector(btnInfinityClicked), for: .touchUpInside)
        self.view().btnRefRosary.addTarget(self, action: #selector(btnRefreshClicked), for: .touchUpInside)
        let totalUserDef:String = userDefaults.object(forKey: "totalCounter") as? String ?? ""
        if totalUserDef != "" {
            self.totalCounter = Int(totalUserDef) ?? 0
            self.view().lblTotalCount.text = "Jami: \(totalUserDef) ta"
        }
        self.view().tasbehs = DataManager.shared.fetchAllTasbehs()
    }
    
    @objc func plusTaped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.view().selectedIndex = -1
        self.view().tableView.reloadData()
        setCounter()
    }
    
    func setCounter(){
        if needVibration {
            ImpactGenerator.panModal.generateImpact()
            playTouch()
        }
        counter += 1
        changeListCount()
        if counter > 33 && !isInfinity{
            counter = 0
            partCounter += 1
        }
        
        totalCounter += 1
        if !isInfinity{
            self.view().lblCunter.text = counter > 9 ? "/\(counter)" : "/0\(counter)"
            self.view().lblPartCount.text = "\(partCounter)"
        }
        self.view().lblTotalCount.text = "Jami: \(totalCounter) ta"
        userDefaults.setValue(String(totalCounter), forKey: "totalCounter")
        let totalUserDef:Int = userDefaults.object(forKey: "totalCounter") as? Int ?? 0
        if totalUserDef == 1000000 {
            userDefaults.setValue(String(0), forKey: "totalCounter")
            self.totalCounter = 0
        }
    }
    
    func playTouch(){
        let url = Bundle.main.url(forResource: "tasbeh_voice", withExtension: "mp3")
        do {
            player = try! AVAudioPlayer(contentsOf: url!)
            player?.play()
        } 
    }
    
    func changeListCount() {
        if self.selectedIndex >= 0 {
            var count = 0
            for i in 0 ..< DataManager.shared.fetchAllTasbehs().count {
                if i == self.selectedIndex {
                    let counter:String = userDefaults.object(forKey: "counter\(i)") as? String ?? ""
                    if counter != ""{
                        count = Int(counter) ?? 0
                        count += 1
                        if count == 1000000 {
                            count = 0
                        }
                    } else {
                        count += 1
                    }
                    userDefaults.setValue(String(count), forKey: "counter\(i)")
                }
            }
            let indexPath = IndexPath(row: self.selectedIndex, section: 0)
            self.view().tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    @objc func btnRefreshClicked() {
        counter = 0
        partCounter = 0
        self.view().lblPartCount.text = self.isInfinity ? "∞" : "\(partCounter)"
        self.view().lblCunter.text = counter > 9 ? "/\(counter)" : "/0\(counter)"
    }
    
    @objc func btnInfinityClicked() {
        self.isInfinity = !self.isInfinity
        if self.isInfinity {
            self.view().lblPartCount.text = "∞"
            self.view().lblCunter.isHidden = true
        } else {
            self.partCounter = 0
            self.counter = 0
            self.view().lblPartCount.text = "\(partCounter)"
            self.view().lblCunter.isHidden = false
            self.view().lblCunter.text = counter > 9 ? "/\(counter)" : "/0\(counter)"
        }
    }
    
    @objc func btnVibrationClicked() {
        self.needVibration = !self.needVibration
        self.needVibration ? self.view().btnVoice.setImage(UIImage(named: "ic_max_volume"), for: .normal) : self.view().btnVoice.setImage(UIImage(named: "ic_mute"), for: .normal)
    }
}

extension RosaryVC:RosaryIxRespoder,AVAudioPlayerDelegate {
    func selectedAudio(index: Int, destination: String) {
        self.selectedIndex = index
        player?.stop()
        configureAudio(destination: destination)
    }
    
    func configureAudio(destination:String){
        guard let desURL = URL(string: destination) else {return}
        do {
            player = try AVAudioPlayer(contentsOf: desURL)
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
        } catch _ {
            player = nil
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.view().selectedIndex = -1
        self.view().tableView.reloadData()
    }
}

extension RosaryVC {
  
    func getCurrentTime()->String{
        let d = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "uz_Latn_UZ")
        dateFormatter.defaultDate = Calendar.current.startOfDay(for: Date())
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: d)
        return time
    }
    
    func timeDifference(start:String, end:String){
        guard let start = Formatter.today.date(from: start),
            let end = Formatter.today.date(from: end) else {
            return
        }
        let elapsedTime = end.timeIntervalSince(start)
        let hours = floor(elapsedTime / 60 / 60)
        let minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        self.hoursLeft = Int(hours)
        self.minutesLeft = Int(minutes)
        timer = Timer.scheduledTimer(timeInterval: 1.00, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerFires(){
        secondsLeft -= 1
        if secondsLeft <= 0 {
            if minutesLeft != 0{
                secondsLeft = 59
                minutesLeft -= 1
            }
        }
        if minutesLeft <= 0 {
            if hoursLeft != 0{
                minutesLeft = 59
                hoursLeft -= 1
            }
        }
        if(hoursLeft == 0 && minutesLeft == 0 && secondsLeft == 0){
            timer.invalidate()
        }
    }
    
    func checkIfCurrentTimeIsBetween(startTime: String, endTime: String) -> Bool {
        guard let start = Formatter.today.date(from: startTime),
              let end = Formatter.today.date(from: endTime) else {
            return false
        }
        return DateInterval(start: start, end: end).contains(Date())
    }
}
