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
import ObjectiveC

// MARK: - Delegate Protocol
protocol QuranStudyPlayerDelegate: AnyObject {
    func didSelectAudio(index: Int, localPath: String)
    func didTapPlayPause()
    func didTapNext()
    func didTapPrevious()
    func didStopAudio()
    func didSeekTo(time: TimeInterval)
}

class QuranStudyRootView: NiblessView {
    
    // MARK: - Outlets
    weak var tableView: UITableView!
    weak var miniPlayerView: UIView!
    weak var miniAvatar: UIImageView!
    weak var miniTitle: Label!
    weak var miniSubtitle: Label!
    weak var miniBtnPlayPause: UIButton!
    weak var miniBtnNext: UIButton!
    weak var miniBtnPrev: UIButton!
    weak var miniBtnClose: UIButton!
    
    // Expanded Player
    weak var expandedPlayerView: UIView!
    weak var exLogoImg: UIImageView!
    weak var exTitle: Label!
    weak var exSubtitle: Label!
    weak var exBtnClose: UIButton!
    weak var exBtnPlayPause: UIButton!
    weak var exBtnNext: UIButton!
    weak var exBtnPrev: UIButton!
    weak var exSlider: UISlider!
    weak var exCurrentTime: Label!
    weak var exTotalTime: Label!
    
    // MARK: - State
    weak var delegate: QuranStudyPlayerDelegate?
    var selectedIndex = -1
    var audioIsPlaying = false
    var videoList = [MediasFiles]()
    
    private var downloadingIndexes = Set<Int>()
    private var downloadTasks: [Int: URLSessionDownloadTask] = [:]
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        setupTableView()
        setupMiniPlayer()
        setupExpandedPlayer()
    }
    
    deinit {
        cleanupDownloads()
    }
    
    // MARK: - Table View Setup
    private func setupTableView() {
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
        addSubview(tbView)
        tbView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        self.tableView = tbView
    }
    
    // MARK: - Mini Player
    private func setupMiniPlayer() {
        let playerView = UIView()
        playerView.backgroundColor = UIColor(named: "bgYellow")
        playerView.isHidden = true
        playerView.layer.cornerRadius = 33
        let tap = UITapGestureRecognizer(target: self, action: #selector(showExpandedPlayer))
        playerView.addGestureRecognizer(tap)
        addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(66)
            make.bottom.equalToSuperview().offset(-30)
        }
        self.miniPlayerView = playerView
        
        // Avatar
        let avatar = UIImageView()
        avatar.contentMode = .scaleAspectFill
        avatar.image = UIImage(named: "ic_audio_avatar")
        playerView.addSubview(avatar)
        avatar.snp.makeConstraints { make in
            make.height.width.equalTo(42)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        self.miniAvatar = avatar
        
        // Close button
        let btnClose = UIButton()
        btnClose.setImage(UIImage(named: "ic_audio_x"), for: .normal)
        btnClose.imageView?.contentMode = .scaleAspectFill
        btnClose.addTarget(self, action: #selector(closeMiniPlayer), for: .touchUpInside)
        playerView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        self.miniBtnClose = btnClose
        
        // Next button
        let btnNext = UIButton()
        btnNext.setImage(UIImage(named: "ic_audio_right"), for: .normal)
        btnNext.imageView?.contentMode = .scaleAspectFill
        btnNext.alpha = 0.3
        btnNext.addTarget(self, action: #selector(nextTrackTapped), for: .touchUpInside)
        playerView.addSubview(btnNext)
        btnNext.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalTo(btnClose.snp.left).offset(-16)
        }
        self.miniBtnNext = btnNext
        
        // Play/Pause button
        let btnPS = UIButton()
        btnPS.setImage(UIImage(named: "ic_audio_play"), for: .normal)
        btnPS.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        btnPS.imageView?.contentMode = .scaleAspectFill
        playerView.addSubview(btnPS)
        btnPS.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalTo(btnNext.snp.left).offset(-16)
        }
        self.miniBtnPlayPause = btnPS
        
        // Previous button
        let btnPrev = UIButton()
        btnPrev.setImage(UIImage(named: "ic_audio_left"), for: .normal)
        btnPrev.imageView?.contentMode = .scaleAspectFill
        btnPrev.alpha = 0.3
        btnPrev.addTarget(self, action: #selector(prevTrackTapped), for: .touchUpInside)
        playerView.addSubview(btnPrev)
        btnPrev.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalTo(btnPS.snp.left).offset(-16)
        }
        self.miniBtnPrev = btnPrev
        
        // Title
        let title = Label(font: UIFont.systemFont(ofSize: 14, weight: .medium), lines: 1, color: .black)
        playerView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(12)
            make.centerY.equalToSuperview().offset(-8)
            make.right.equalTo(btnPrev.snp.left).offset(-12)
        }
        self.miniTitle = title
        
        // Subtitle
        let subtitle = Label(font: UIFont.systemFont(ofSize: 11, weight: .regular), lines: 1, color: .black.withAlphaComponent(0.7))
        playerView.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(12)
            make.centerY.equalToSuperview().offset(8)
            make.right.equalTo(btnPrev.snp.left).offset(-12)
        }
        self.miniSubtitle = subtitle
    }
    
    // MARK: - Expanded Player
    private func setupExpandedPlayer() {
        let biometryType = Configs().biometricType()
        
        let exView = UIView()
        exView.backgroundColor = UIColor(named: "bgMain")
        exView.isHidden = true
        addSubview(exView)
        exView.snp.makeConstraints { $0.edges.equalToSuperview() }
        self.expandedPlayerView = exView
        
        // Close button
        let btnClose = UIButton()
        btnClose.setImage(UIImage(named: "ic_cancel"), for: .normal)
        btnClose.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btnClose.addTarget(self, action: #selector(hideExpandedPlayer), for: .touchUpInside)
        exView.addSubview(btnClose)
        btnClose.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(biometryType == .face ? 40 : 20)
            make.width.height.equalTo(50)
        }
        self.exBtnClose = btnClose
        
        // Logo
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "ic_logo_audio")
        logo.layer.cornerRadius = 20
        logo.clipsToBounds = true
        exView.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(btnClose.snp.bottom).offset(40)
            make.width.height.equalTo(200)
        }
        self.exLogoImg = logo
        
        // Title
        let exTitleLbl = Label(font: UIFont.systemFont(ofSize: 22, weight: .bold), lines: 2, color: .white)
        exTitleLbl.textAlignment = .center
        exView.addSubview(exTitleLbl)
        exTitleLbl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(logo.snp.bottom).offset(30)
        }
        self.exTitle = exTitleLbl
        
        // Subtitle
        let exSubLbl = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white.withAlphaComponent(0.7))
        exSubLbl.textAlignment = .center
        exView.addSubview(exSubLbl)
        exSubLbl.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(exTitleLbl.snp.bottom).offset(8)
        }
        self.exSubtitle = exSubLbl
        
        // Slider
        let slider = UISlider()
        slider.minimumTrackTintColor = UIColor(named: "bgYellow")
        slider.maximumTrackTintColor = .white.withAlphaComponent(0.3)
        slider.thumbTintColor = UIColor(named: "bgYellow")
        slider.value = 0
        exView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(30)
            make.top.equalTo(exSubLbl.snp.bottom).offset(30)
        }
        self.exSlider = slider
        
        // Current time
        let currentTimeLbl = Label(font: UIFont.systemFont(ofSize: 12, weight: .regular), lines: 1, color: .white.withAlphaComponent(0.7), text: "00:00")
        exView.addSubview(currentTimeLbl)
        currentTimeLbl.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(slider.snp.bottom).offset(4)
        }
        self.exCurrentTime = currentTimeLbl
        
        // Total time
        let totalTimeLbl = Label(font: UIFont.systemFont(ofSize: 12, weight: .regular), lines: 1, color: .white.withAlphaComponent(0.7), text: "00:00")
        totalTimeLbl.textAlignment = .right
        exView.addSubview(totalTimeLbl)
        totalTimeLbl.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.top.equalTo(slider.snp.bottom).offset(4)
        }
        self.exTotalTime = totalTimeLbl
        
        // Control buttons container
        let controlsContainer = UIView()
        exView.addSubview(controlsContainer)
        controlsContainer.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(slider.snp.bottom).offset(40)
            make.height.equalTo(60)
            make.width.equalTo(240)
        }
        
        // Play/Pause (center)
        let exPlayPause = UIButton()
        exPlayPause.setImage(UIImage(named: "ic_audio_white_play"), for: .normal)
        exPlayPause.imageView?.contentMode = .scaleAspectFit
        exPlayPause.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        controlsContainer.addSubview(exPlayPause)
        exPlayPause.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        self.exBtnPlayPause = exPlayPause
        
        // Next
        let exNext = UIButton()
        exNext.setImage(UIImage(named: "ic_audio_right"), for: .normal)
        exNext.imageView?.contentMode = .scaleAspectFit
        exNext.addTarget(self, action: #selector(nextTrackTapped), for: .touchUpInside)
        controlsContainer.addSubview(exNext)
        exNext.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(exPlayPause.snp.right).offset(30)
            make.width.height.equalTo(36)
        }
        self.exBtnNext = exNext
        
        // Previous
        let exPrev = UIButton()
        exPrev.setImage(UIImage(named: "ic_audio_left"), for: .normal)
        exPrev.imageView?.contentMode = .scaleAspectFit
        exPrev.addTarget(self, action: #selector(prevTrackTapped), for: .touchUpInside)
        controlsContainer.addSubview(exPrev)
        exPrev.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(exPlayPause.snp.left).offset(-30)
            make.width.height.equalTo(36)
        }
        self.exBtnPrev = exPrev
    }
}

// MARK: - Player Actions
extension QuranStudyRootView {
    
    @objc private func showExpandedPlayer() {
        guard selectedIndex >= 0 && selectedIndex < videoList.count else { return }
        expandedPlayerView.isHidden = false
    }
    
    @objc func hideExpandedPlayer() {
        expandedPlayerView.isHidden = true
    }
    
    @objc private func closeMiniPlayer() {
        miniPlayerView.isHidden = true
        expandedPlayerView.isHidden = true
        selectedIndex = -1
        audioIsPlaying = false
        delegate?.didStopAudio()
        
        // Reset table inset since mini player is hidden
        tableView.contentInset = .zero
        
        for (_, task) in downloadTasks {
            task.cancel()
        }
        downloadTasks.removeAll()
        downloadingIndexes.removeAll()
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc private func playPauseTapped() {
        delegate?.didTapPlayPause()
    }
    
    @objc private func nextTrackTapped() {
        delegate?.didTapNext()
    }
    
    @objc private func prevTrackTapped() {
        delegate?.didTapPrevious()
    }
    
    // MARK: - Update Mini Player UI
    func updateMiniPlayer(title: String, duration: String, isPlaying: Bool) {
        miniPlayerView.isHidden = false
        miniTitle.text = title
        miniSubtitle.text = duration
        
        let playIcon = isPlaying ? "ic_audio_stop" : "ic_audio_play"
        miniBtnPlayPause.setImage(UIImage(named: playIcon), for: .normal)
        
        let exPlayIcon = isPlaying ? "ic_audio_white_stop" : "ic_audio_white_play"
        exBtnPlayPause.setImage(UIImage(named: exPlayIcon), for: .normal)
        
        updateNavigationButtons()
        
        // Update table bottom inset for mini player
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
    }
    
    func updateExpandedPlayer(title: String, duration: String, currentTime: String, totalTime: String, sliderValue: Float, sliderMax: Float) {
        exTitle.text = title
        exSubtitle.text = duration
        exCurrentTime.text = currentTime
        exTotalTime.text = totalTime
        exSlider.maximumValue = sliderMax
        exSlider.value = sliderValue
    }
    
    func updatePlayPauseIcon(isPlaying: Bool) {
        let miniIcon = isPlaying ? "ic_audio_stop" : "ic_audio_play"
        miniBtnPlayPause.setImage(UIImage(named: miniIcon), for: .normal)
        
        let exIcon = isPlaying ? "ic_audio_white_stop" : "ic_audio_white_play"
        exBtnPlayPause.setImage(UIImage(named: exIcon), for: .normal)
    }
    
    func updateNavigationButtons() {
        let downloadedIndexes = getDownloadedAudioIndexes()
        
        guard !downloadedIndexes.isEmpty else {
            miniBtnPrev.alpha = 0.3
            miniBtnPrev.isEnabled = false
            miniBtnNext.alpha = 0.3
            miniBtnNext.isEnabled = false
            exBtnPrev?.alpha = 0.3
            exBtnPrev?.isEnabled = false
            exBtnNext?.alpha = 0.3
            exBtnNext?.isEnabled = false
            return
        }
        
        if let currentPos = downloadedIndexes.firstIndex(of: selectedIndex) {
            let hasPrev = currentPos > 0
            let hasNext = currentPos < downloadedIndexes.count - 1
            
            miniBtnPrev.alpha = hasPrev ? 1.0 : 0.3
            miniBtnPrev.isEnabled = hasPrev
            miniBtnNext.alpha = hasNext ? 1.0 : 0.3
            miniBtnNext.isEnabled = hasNext
            
            exBtnPrev?.alpha = hasPrev ? 1.0 : 0.3
            exBtnPrev?.isEnabled = hasPrev
            exBtnNext?.alpha = hasNext ? 1.0 : 0.3
            exBtnNext?.isEnabled = hasNext
        }
    }
    
    func getDownloadedAudioIndexes() -> [Int] {
        var indexes: [Int] = []
        for i in 0..<videoList.count {
            if checkIsDownloaded(index: i) {
                indexes.append(i)
            }
        }
        return indexes
    }
    
    func getNextDownloadedIndex(after current: Int) -> Int? {
        let downloaded = getDownloadedAudioIndexes()
        guard let pos = downloaded.firstIndex(of: current) else { return downloaded.first }
        let nextPos = pos + 1
        return nextPos < downloaded.count ? downloaded[nextPos] : nil
    }
    
    func getPreviousDownloadedIndex(before current: Int) -> Int? {
        let downloaded = getDownloadedAudioIndexes()
        guard let pos = downloaded.firstIndex(of: current) else { return nil }
        let prevPos = pos - 1
        return prevPos >= 0 ? downloaded[prevPos] : nil
    }
}

// MARK: - Download Logic
extension QuranStudyRootView {
    
    func checkIsDownloaded(index: Int) -> Bool {
        guard index >= 0 && index < videoList.count else { return false }
        let myURL = videoList[index].file_url ?? ""
        guard let audioUrl = URL(string: myURL) else { return false }
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDir.appendingPathComponent(audioUrl.lastPathComponent)
        return FileManager.default.fileExists(atPath: destinationUrl.path)
    }
    
    func getLocalPath(for index: Int) -> String? {
        guard index >= 0 && index < videoList.count else { return nil }
        let myURL = videoList[index].file_url ?? ""
        guard let audioUrl = URL(string: myURL) else { return nil }
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDir.appendingPathComponent(audioUrl.lastPathComponent)
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            return destinationUrl.absoluteString
        }
        return nil
    }
    
    @objc func downloadTapped(sender: UIButton) {
        let index = sender.tag
        guard index >= 0 && index < videoList.count else { return }
        
        if downloadingIndexes.contains(index) {
            cancelDownload(at: index)
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? QuranStudyCell {
            cell.downloadBtn.isEnabled = true
            cell.downloadImg.isHidden = true
            cell.showDownloadProgress()
            DispatchQueue.main.async {
                cell.updateDownloadProgress(0.0)
            }
        }
        
        downloadingIndexes.insert(index)
        downloadFileAtIndex(index: index)
    }
    
    func downloadFileAtIndex(index: Int) {
        guard index >= 0 && index < videoList.count else {
            downloadingIndexes.remove(index)
            return
        }
        
        let myURL = videoList[index].file_url ?? ""
        guard let audioUrl = URL(string: myURL) else {
            downloadingIndexes.remove(index)
            return
        }
        
        let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsDir.appendingPathComponent(audioUrl.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: destinationUrl.path) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.downloadingIndexes.remove(index)
                self.onDownloadComplete(index: index, localPath: destinationUrl.absoluteString)
            }
            return
        }
        
        downloadTasks[index]?.cancel()
        
        let downloadTask = URLSession.shared.downloadTask(with: audioUrl) { [weak self] location, response, error in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.downloadingIndexes.remove(index)
                self.downloadTasks.removeValue(forKey: index)
            }
            
            guard let location = location, error == nil else {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: 0)
                    if let cell = self.tableView.cellForRow(at: indexPath) as? QuranStudyCell {
                        cell.showDownloadButton()
                        cell.downloadBtn.isEnabled = true
                    }
                }
                return
            }
            
            do {
                try FileManager.default.moveItem(at: location, to: destinationUrl)
                DispatchQueue.main.async {
                    self.onDownloadComplete(index: index, localPath: destinationUrl.absoluteString)
                }
            } catch {
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: 0)
                    if let cell = self.tableView.cellForRow(at: indexPath) as? QuranStudyCell {
                        cell.showDownloadButton()
                        cell.downloadBtn.isEnabled = true
                    }
                }
            }
        }
        
        downloadTasks[index] = downloadTask
        
        let observation = downloadTask.progress.observe(\.fractionCompleted) { [weak self] progress, _ in
            let progressValue = Float(progress.fractionCompleted)
            DispatchQueue.main.async {
                guard let self = self, self.downloadingIndexes.contains(index) else { return }
                let indexPath = IndexPath(row: index, section: 0)
                if let cell = self.tableView.cellForRow(at: indexPath) as? QuranStudyCell {
                    cell.updateDownloadProgress(progressValue)
                }
            }
        }
        
        objc_setAssociatedObject(downloadTask, "progressObservation", observation, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        downloadTask.resume()
    }
    
    private func onDownloadComplete(index: Int, localPath: String) {
        selectedIndex = index
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? QuranStudyCell {
            cell.hideDownloadProgress()
        }
        
        delegate?.didSelectAudio(index: index, localPath: localPath)
        tableView.reloadData()
    }
    
    func cancelDownload(at index: Int) {
        downloadingIndexes.remove(index)
        if let task = downloadTasks[index] {
            task.cancel()
            downloadTasks.removeValue(forKey: index)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.tableView.cellForRow(at: indexPath) as? QuranStudyCell {
                cell.hideDownloadProgress()
                cell.downloadBtn.isEnabled = true
                cell.downloadImg.image = UIImage(named: "ic_download")?.withRenderingMode(.alwaysTemplate)
                cell.downloadImg.tintColor = UIColor(named: "bgYellow")
            }
        }
    }
    
    func cleanupDownloads() {
        for (_, task) in downloadTasks {
            task.cancel()
        }
        downloadTasks.removeAll()
        downloadingIndexes.removeAll()
    }
}

// MARK: - Table View
extension QuranStudyRootView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuranStudyCell.className) as? QuranStudyCell else {
            return UITableViewCell()
        }
        
        let item = videoList[indexPath.row]
        cell.lblTittle.text = item.name?.replacingOccurrences(of: "^", with: "'")
        cell.lblOrder.text = indexPath.row >= 9 ? "\(indexPath.row + 1)" : "0\(indexPath.row + 1)"
        
        let prefixTime = item.duration?.prefix(2)
        cell.lblTime.text = prefixTime == "00" ? "\(String(item.duration?.dropFirst(3) ?? ""))" : "\(item.duration ?? "")"
        
        // Download button
        cell.downloadBtn.removeTarget(nil, action: nil, for: .allEvents)
        cell.downloadBtn.tag = indexPath.row
        cell.downloadBtn.addTarget(self, action: #selector(downloadTapped(sender:)), for: .touchUpInside)
        
        let isDownloading = downloadingIndexes.contains(indexPath.row)
        
        if isDownloading {
            cell.downloadBtn.isEnabled = true
            cell.downloadImg.isHidden = true
            cell.showDownloadProgress()
        } else if checkIsDownloaded(index: indexPath.row) {
            cell.downloadImg.image = UIImage(named: "ic_check")?.withRenderingMode(.alwaysTemplate)
            cell.downloadImg.tintColor = indexPath.row == selectedIndex ? UIColor(named: "bgMain") : UIColor(named: "bgYellow")
            cell.downloadBtn.isEnabled = false
            cell.showDownloadButton()
        } else {
            cell.downloadImg.image = UIImage(named: "ic_download")?.withRenderingMode(.alwaysTemplate)
            cell.downloadImg.tintColor = UIColor(named: "bgYellow")
            cell.downloadBtn.isEnabled = true
            cell.showDownloadButton()
        }
        
        // Selected state
        if indexPath.row == selectedIndex {
            cell.viewBG.backgroundColor = UIColor(named: "bgYellow")
            cell.playBtn.isHidden = false
            cell.lblOrder.isHidden = true
            cell.lblTittle.textColor = .black
            cell.lblTime.textColor = .black.withAlphaComponent(0.9)
            cell.downloadImg.tintColor = UIColor(named: "bgMain")
            cell.playBtn.setImage(UIImage(named: audioIsPlaying ? "ic_audio_stop" : "ic_play_yellow"), for: .normal)
        } else {
            cell.viewBG.backgroundColor = .clear
            cell.playBtn.isHidden = true
            cell.lblOrder.isHidden = false
            cell.lblTittle.textColor = .white
            cell.lblTime.textColor = .white
        }
        
        if isDownloading {
            cell.downloadImg.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard indexPath.row >= 0 && indexPath.row < videoList.count else { return }
        
        if downloadingIndexes.contains(indexPath.row) {
            cancelDownload(at: indexPath.row)
            return
        }
        
        if checkIsDownloaded(index: indexPath.row) {
            // Already downloaded — play it
            selectedIndex = indexPath.row
            if let localPath = getLocalPath(for: indexPath.row) {
                delegate?.didSelectAudio(index: indexPath.row, localPath: localPath)
            }
            tableView.reloadData()
        } else {
            // Start download
            downloadingIndexes.insert(indexPath.row)
            let indexPathCell = IndexPath(row: indexPath.row, section: 0)
            if let cell = tableView.cellForRow(at: indexPathCell) as? QuranStudyCell {
                cell.downloadImg.isHidden = true
                cell.showDownloadProgress()
                DispatchQueue.main.async {
                    cell.updateDownloadProgress(0.0)
                }
            }
            downloadFileAtIndex(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? QuranStudyCell else { return }
        cell.viewBG.backgroundColor = .clear
        cell.playBtn.isHidden = true
        cell.lblOrder.isHidden = false
        cell.lblTittle.textColor = .white
        cell.lblTime.textColor = .white
    }
}
