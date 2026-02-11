//
//  QuranBribesvc.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary
import AVFoundation
import PDFKit
import Kingfisher
import FirebaseStorage


class QuranBribesVC:UIViewController,ViewSpecificController {
    
    typealias RootView = QuranBribesRootView
    weak var coordinator: MainCoordinator?
    var player:AVAudioPlayer?
    private var destonation = String()
    private var timer:Timer?
    private var selectedAudio:MediasFiles?
    private var selectedIndex = -1
    private var quranSurahs = [MediasFiles]()
    
    override func loadView() {
        let rootView = QuranBribesRootView()
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
            MainBean.shared.needStopFirebase = true
        }
        if let rootView = view as? QuranBribesRootView {
            rootView.cleanupDownloads()
        }
    }
    private func appearanceSettings() {
        self.navigationItem.title = "Qur'on poralari"
        self.view().delegate = self
        self.quranSurahs = DataManager.shared.fetchAllQuranSurahs()
        
        self.view().bribesList = self.quranSurahs
    }
}

extension QuranBribesVC:QuranBribesIxRespoder,AVAudioPlayerDelegate {

    func selectedAudio(index: Int, destination: String) {
        self.selectedIndex = index
        self.downloadImgs(sora: index+1)
        self.stopAudio()
        selectedAudio = self.quranSurahs[index]
        self.configureAudio(item: selectedAudio, destination: destination)
    }
    
    func downloadImgs(sora:Int){
        
        let pages = QuranBribesModel().getPages(sora: sora)
        guard let pageInit = pages.first, let pageLast = pages.last else { return }
        self.view().quranImages = [UIImage]()
        MainBean.shared.needStopFirebase = false
        print("Downloading:page -------")
        self.getImages(pageInit: pageInit, pageLast: pageLast)
    }
    
    func getImages(pageInit:Int,pageLast:Int){
        
        if MainBean.shared.needStopFirebase || !QuranBribesModel().getPages(sora: self.selectedIndex+1).contains(where: {$0 == pageInit}) { return }
        
        
        var id = String()
        var page = pageInit
        if page<10{
            id = "00\(page)"
        }else if page<100{
            id = "0\(page)"
        }else{
            id = "\(page)"
        }
        page += 1
        let storageRef = Storage.storage().reference()
        let islandRef = storageRef.child("images/page\(id).png")
        
        print("Downloading:page\(id)")
      
        islandRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                if pageInit<=pageLast{
                    DispatchQueue.main.async {
                        self.view().quranImages.append(UIImage(named: "ic_logo_audio")!)
                    }
                    self.getImages(pageInit: page, pageLast: pageLast)
                }else{
                    DispatchQueue.main.async {
                        self.view().imgCollectionView.reloadData()
                    }
                }
            } else {
                let image = UIImage(data: data!)
                
                if pageInit<=pageLast{
                    if !QuranBribesModel().getPages(sora: self.selectedIndex+1).contains(where: {$0 == pageInit}) { return }
                    DispatchQueue.main.async {
                        self.view().quranImages.append(image ?? UIImage(named: "ic_logo_audio")!)
                    }
                    self.getImages(pageInit: page, pageLast: pageLast)
                }else{
                    DispatchQueue.main.async {
                        self.view().imgCollectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
    func configureAudio(item:MediasFiles?, destination:String){
        self.destonation = destination
        guard let desURL = URL(string: destination), let item = item else {return}
        do {
            player = try AVAudioPlayer(contentsOf: desURL)
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
            DispatchQueue.main.async {
                self.view().tableView.reloadData()
                self.view().exSlider.maximumValue = Float(self.player?.duration ?? 0)
                self.view().btnPlayStop.setImage(UIImage(named: "ic_audio_stop"), for: .normal)
                self.view().exBtnPlayStop.setImage(UIImage(named: "ic_audio_white_stop"), for: .normal)
                self.setExpendedItems(item: item)
            }
        } catch _ {
            player = nil
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.view().btnPlayStop.setImage(UIImage(named: "ic_audio_play"), for: .normal)
        self.view().exBtnPlayStop.setImage(UIImage(named: "ic_audio_white_play"), for: .normal)
        self.view().audioIsPlay = false
    }
   
    func stopAudio() {
        if let player = player {
            player.stop()
        }
    }
    
    func stopPlayAudio(state: Bool) {
        if let player = player {
            if state {
                player.pause()
                self.view().exBtnPlayStop.setImage(UIImage(named: "ic_audio_white_play"), for: .normal)
                self.view().btnPlayStop.setImage(UIImage(named: "ic_audio_play"), for: .normal)
            } else{
                player.play()
                self.view().exBtnPlayStop.setImage(UIImage(named: "ic_audio_white_stop"), for: .normal)
                self.view().btnPlayStop.setImage(UIImage(named: "ic_audio_stop"), for: .normal)
            }
        }
    }
    
    func setExpendedItems(item:MediasFiles){
        self.view().exAudioTittle.text = item.name
        self.view().exTitle.text = item.name
        let count:String = String(item.verses_count ?? 0)
        let placeType = Configs().chekMakOrMad(placeType: item.place_type ?? "")
        self.view().exAudioSubtitle.text = "\(placeType)\(count) oyatdan iborat"
        let prefixTime = item.duration?.prefix(2)
        self.view().exAudioTime.text = prefixTime == "00" ? "\(String(item.duration?.dropFirst(3) ?? ""))" : "\(item.duration ?? "")"
        self.view().exSlider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        _ = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    @objc func sliderValueChanged(sender:AnyObject) {
        if let player = player {
            player.stop()
            player.currentTime = TimeInterval(self.view().exSlider.value)
            player.prepareToPlay()
            player.play()
        }
    }
    
    @objc func updateSlider() {
        if let player = player{
            self.view().exSlider.value = Float(player.currentTime)
        }
    }
}

