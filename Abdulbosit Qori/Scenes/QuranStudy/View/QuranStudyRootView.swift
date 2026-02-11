//
//  QuranStudyRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary
import AVFoundation
import AVKit

class QuranStudyRootView: NiblessView {
    
    // MARK: - Outlets
    weak var videoView:UIView!
    weak var tableView:UITableView!
    private var selectedIndex = -1
    private var curentIndex = -1
    
    private var videoURL = ""
    private var avpController = AVPlayerViewController()
    private var activityIndicator: UIActivityIndicatorView!
    var player = AVPlayer()
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        setupBodyView()
    }
    
    private func setupBodyView() {
        
        let videoview = UIView()
        videoview.backgroundColor = .black
        videoview.isHidden = true
        self.videoView = videoview
        
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.tableHeaderView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(QuranStudyCell.self, forCellReuseIdentifier: QuranStudyCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.separatorColor = UIColor.white.withAlphaComponent(0.3)
        tbView.rowHeight = 70
        self.tableView = tbView
        
        let stack = StackView(axis: .vertical, alignment: .fill, distribution: .fill, spacing: 10, views: [videoview,tbView])
        addSubview(stack)
        stack.snp.makeConstraints({$0.edges.equalToSuperview()})
        self.videoView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.main.bounds.height*0.3)
        }
    }
}

extension QuranStudyRootView {
    
    func playVideo() {
        
        let urlSrting = DataManager.shared.fetchAllVideos()[self.selectedIndex].file_url?.replacingOccurrences(of: "^", with: "%5E")
        guard let url = URL(string: urlSrting ?? "") else {return}
        self.player = AVPlayer(url: url)
        avpController.player = player
        avpController.view.frame.size.height = self.videoView.frame.height
        avpController.view.frame.size.width = self.videoView.frame.width
        self.videoView.addSubview(avpController.view)
        player.play()
        player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.startAnimating()
        self.videoView.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.activityIndicator = indicator
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === player {
            if keyPath == "timeControlStatus" {
                if player.timeControlStatus == .playing || player.timeControlStatus == .paused {
                    self.activityIndicator.stopAnimating()
                } else {
                    self.activityIndicator.startAnimating()
                }
            }
        }
    }
}

extension QuranStudyRootView:UITableViewDataSource, UITableViewDelegate{
   
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataManager.shared.fetchAllVideos().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuranStudyCell.className
        ) as? QuranStudyCell else { return UITableViewCell() }
        let item = DataManager.shared.fetchAllVideos()[indexPath.row]
        cell.lblTittle.text = item.name?.replacingOccurrences(of: "^", with: "'")
        let prefixTime = item.duration?.prefix(2)
        cell.lblTime.text = prefixTime == "00" ? "\(String(item.duration?.dropFirst(3) ?? ""))" : "\(item.duration ?? "")"
        
        if selectedIndex == indexPath.row {
            cell.viewBG.backgroundColor = UIColor(named: "bgYellow")
            cell.playBtn.setImage(UIImage(named: "ic_audio_stop"), for: .normal)
            cell.lblTittle.textColor = .black
            cell.lblTime.textColor = .black
        } else {
            cell.viewBG.backgroundColor = .clear
            cell.playBtn.setImage(UIImage(named: "ic_play_yellow"), for: .normal)
            cell.lblTittle.textColor = .white
            cell.lblTime.textColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.videoView.isHidden = false
        let cell = tableView.cellForRow(at:indexPath ) as! QuranStudyCell
        cell.viewBG.backgroundColor = UIColor(named: "bgYellow")
        cell.playBtn.setImage(UIImage(named: "ic_audio_stop"), for: .normal)
        cell.lblTittle.textColor = .black
        cell.lblTime.textColor = .black
        if self.curentIndex != indexPath.row {
            player.pause()
            playVideo()
        }
        self.curentIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at:indexPath ) as? QuranStudyCell else { return }
        cell.viewBG.backgroundColor = .clear
        cell.playBtn.setImage(UIImage(named: "ic_play_yellow"), for: .normal)
        cell.lblTittle.textColor = .white
        cell.lblTime.textColor = .white
    }
}

