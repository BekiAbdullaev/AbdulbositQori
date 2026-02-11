//
//  QuranStudyVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary
import AVFoundation

class QuranStudyVC: UIViewController, ViewSpecificController {
    
    // MARK: - RootView
    typealias RootView = QuranStudyRootView
    weak var coordinator: MainCoordinator?
    
    // MARK: - Audio Player
    private var player: AVAudioPlayer?
    private var sliderTimer: Timer?
    private var currentTrackIndex = -1
    
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
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
        sliderTimer?.invalidate()
        sliderTimer = nil
        self.view().hideExpandedPlayer()
    }
    
    deinit {
        sliderTimer?.invalidate()
        sliderTimer = nil
        player?.stop()
        player = nil
        if let rootView = view as? QuranStudyRootView {
            rootView.cleanupDownloads()
        }
    }
    
    // MARK: - Setup
    private func appearanceSettings() {
        self.navigationItem.title = "Quron ta'limi"
        self.view().delegate = self
        self.view().videoList = DataManager.shared.fetchAllVideos()
        
        // Setup expanded player slider
        self.view().exSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // Setup audio session
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session xatosi: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Audio Playback
    private func playAudio(at index: Int, localPath: String) {
        // Stop current
        player?.stop()
        sliderTimer?.invalidate()
        sliderTimer = nil
        
        guard let url = URL(string: localPath) else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.delegate = self
            player?.play()
            
            currentTrackIndex = index
            self.view().selectedIndex = index
            self.view().audioIsPlaying = true
            
            // Update UI
            let item = self.view().videoList[index]
            let title = item.name?.replacingOccurrences(of: "^", with: "'") ?? ""
            let prefixTime = item.duration?.prefix(2)
            let duration = prefixTime == "00" ? "\(String(item.duration?.dropFirst(3) ?? ""))" : "\(item.duration ?? "")"
            
            self.view().updateMiniPlayer(title: title, duration: duration, isPlaying: true)
            
            // Setup expanded player
            let totalTime = formatTime(player?.duration ?? 0)
            self.view().updateExpandedPlayer(
                title: title,
                duration: duration,
                currentTime: "00:00",
                totalTime: totalTime,
                sliderValue: 0,
                sliderMax: Float(player?.duration ?? 0)
            )
            
            // Start slider timer
            startSliderTimer()
            
            self.view().tableView.reloadData()
            
        } catch {
            print("Audio ijro etishda xatolik: \(error.localizedDescription)")
            player = nil
        }
    }
    
    private func startSliderTimer() {
        sliderTimer?.invalidate()
        sliderTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            self?.updateSliderProgress()
        }
    }
    
    private func updateSliderProgress() {
        guard let player = player else { return }
        let currentTime = formatTime(player.currentTime)
        self.view().exSlider.value = Float(player.currentTime)
        self.view().exCurrentTime.text = currentTime
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        guard let player = player else { return }
        player.currentTime = TimeInterval(sender.value)
    }
    
    // MARK: - Auto-Next
    private func playNextTrack() {
        guard let nextIndex = self.view().getNextDownloadedIndex(after: currentTrackIndex) else {
            // No next track — stop
            self.view().audioIsPlaying = false
            self.view().updatePlayPauseIcon(isPlaying: false)
            self.view().updateNavigationButtons()
            self.view().tableView.reloadData()
            return
        }
        
        if let localPath = self.view().getLocalPath(for: nextIndex) {
            playAudio(at: nextIndex, localPath: localPath)
        }
    }
    
    private func playPreviousTrack() {
        guard let prevIndex = self.view().getPreviousDownloadedIndex(before: currentTrackIndex) else {
            return
        }
        
        if let localPath = self.view().getLocalPath(for: prevIndex) {
            playAudio(at: prevIndex, localPath: localPath)
        }
    }
    
    // MARK: - Helper
    private func formatTime(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - AVAudioPlayerDelegate
extension QuranStudyVC: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Auto-next: ketganda keyingi track'ga o'tish
        playNextTrack()
    }
}

// MARK: - QuranStudyPlayerDelegate
extension QuranStudyVC: QuranStudyPlayerDelegate {
    
    func didSelectAudio(index: Int, localPath: String) {
        playAudio(at: index, localPath: localPath)
    }
    
    func didTapPlayPause() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.pause()
            sliderTimer?.invalidate()
            self.view().audioIsPlaying = false
            self.view().updatePlayPauseIcon(isPlaying: false)
        } else {
            player.play()
            startSliderTimer()
            self.view().audioIsPlaying = true
            self.view().updatePlayPauseIcon(isPlaying: true)
        }
        
        self.view().tableView.reloadData()
    }
    
    func didTapNext() {
        playNextTrack()
    }
    
    func didTapPrevious() {
        // 3 sekunddan keyin — track boshiga qaytadi
        if let player = player, player.currentTime > 3 {
            player.currentTime = 0
            self.view().exSlider.value = 0
            self.view().exCurrentTime.text = "00:00"
        } else {
            playPreviousTrack()
        }
    }
    
    func didStopAudio() {
        player?.stop()
        player = nil
        sliderTimer?.invalidate()
        sliderTimer = nil
        currentTrackIndex = -1
        self.view().audioIsPlaying = false
        self.view().selectedIndex = -1
        self.view().tableView.reloadData()
    }
    
    func didSeekTo(time: TimeInterval) {
        player?.currentTime = time
    }
}
