//
//  QuranBribesRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary
import ObjectiveC

protocol QuranBribesIxRespoder:AnyObject {
    func selectedAudio(index:Int, destination:String)
    func stopAudio()
    func stopPlayAudio(state:Bool)
}

class QuranBribesRootView: NiblessView {
    
    weak var tableView:UITableView!
    weak var audioView:UIView!
   
    weak var btnX:UIButton!
    weak var btnR:UIButton!
    weak var btnPlayStop:UIButton!
    weak var btnL:UIButton!
    weak var audioTittle:Label!
    weak var audioSubtitle:Label!
    
    weak var expendedAudioView:UIView!
    weak var exBodyView:UIView!
    weak var exBtnCancel:UIButton!
    weak var exBtnBook:UIButton!
    weak var exLogoImg:UIImageView!
    weak var exBtnR:UIButton!
    weak var exBtnPlayStop:UIButton!
    weak var exBtnL:UIButton!
    weak var exTitle:Label!
    weak var exAudioTittle:Label!
    weak var exAudioSubtitle:Label!
    weak var exAudioTime:Label!
    weak var exSlider:UISlider!
    
    weak var pdfView:UIView!
    weak var imgCollectionView: UICollectionView!
  
    
    weak var delegate:QuranBribesIxRespoder?
    let biometryType = Configs().biometricType()
    var selectedIndex = -1
    private var audioURL = ""
    var audioIsPlay = false
    var isBookVisible = false
    
    private var downloadingIndexes = Set<Int>()
    private var downloadTasks: [Int: URLSessionDownloadTask] = [:]
    
    var quranImages = [UIImage](){
        didSet{
            DispatchQueue.main.async { [weak self] in
                guard let self = self, let collectionView = self.imgCollectionView else { return }
                collectionView.reloadData()
            }
        }
    }
    var bribesList = [MediasFiles]() {
        didSet {
            if selectedIndex >= bribesList.count {
                selectedIndex = -1
                audioView?.isHidden = true
            }
            
            downloadingIndexes = downloadingIndexes.filter { $0 < bribesList.count }
            
            for (index, task) in downloadTasks {
                if index >= bribesList.count {
                    task.cancel()
                    downloadTasks.removeValue(forKey: index)
                }
            }
            
            tableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        self.setupTableView()
        self.setupAudioView()
        self.setUpExpendview()
    }
    
    deinit {
        cleanupDownloads()
    }
        
    private func setupTableView() {
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.tableHeaderView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(QuranBribesCell.self, forCellReuseIdentifier: QuranBribesCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.separatorColor = UIColor.white.withAlphaComponent(0.3)
        tbView.rowHeight = 70
        addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalToSuperview()
        }
        self.tableView = tbView
    }
    
    private func setupAudioView(){
        let audioView = UIView()
        audioView.backgroundColor = UIColor(named: "bgYellow")
        audioView.isHidden = true
        audioView.layer.cornerRadius = 33
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        audioView.addGestureRecognizer(tap)
        addSubview(audioView)
        audioView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(66)
            make.bottom.equalToSuperview().offset(-30)
        }
        self.audioView = audioView
                
        let imgAvatar = UIImageView()
        imgAvatar.contentMode = .scaleAspectFill
        imgAvatar.image = UIImage(named: "ic_audio_avatar")
        audioView.addSubview(imgAvatar)
        imgAvatar.snp.makeConstraints { make in
            make.height.width.equalTo(42)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        }
        
        let btnX = UIButton()
        btnX.setImage(UIImage(named: "ic_audio_x"), for: .normal)
        btnX.imageView?.contentMode = .scaleAspectFill
        btnX.addTarget(self, action: #selector(cancelAudio), for: .touchUpInside)
        audioView.addSubview(btnX)
        btnX.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        self.btnX = btnX
        
        let btnR = UIButton()
        btnR.setImage(UIImage(named: "ic_audio_right"), for: .normal)
        btnR.imageView?.contentMode = .scaleAspectFill
        btnR.alpha = 0.3
        btnR.addTarget(self, action: #selector(nextAudioCollapsed), for: .touchUpInside)
        audioView.addSubview(btnR)
        btnR.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.btnX.snp.left).offset(-16)
        }
        self.btnR = btnR
        
        let btnPS = UIButton()
        btnPS.setImage(UIImage(named: "ic_audio_play"), for: .normal)
        btnPS.addTarget(self, action: #selector(playStopAudio), for: .touchUpInside)
        btnPS.imageView?.contentMode = .scaleAspectFill
        audioView.addSubview(btnPS)
        btnPS.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(32)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.btnR.snp.left).offset(-16)
        }
        self.btnPlayStop = btnPS
        
        
        
        let btnL = UIButton()
        btnL.setImage(UIImage(named: "ic_audio_left"), for: .normal)
        btnL.imageView?.contentMode = .scaleAspectFill
        btnL.alpha = 0.3
        btnL.addTarget(self, action: #selector(previousAudioCollapsed), for: .touchUpInside)
        audioView.addSubview(btnL)
        btnL.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.btnPlayStop.snp.left).offset(-16)
        }
        self.btnL = btnL
        
        let lblTitle = Label(font: UIFont.systemFont(ofSize: 14, weight: .medium), lines: 1, color: .black)
        audioView.addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.left.equalTo(imgAvatar.snp.right).offset(16)
            make.centerY.equalToSuperview().offset(-8)
            make.right.equalTo(self.btnL.snp.left).offset(-12)
        }
        self.audioTittle = lblTitle
        
        let lblSubtitle = Label(font: UIFont.systemFont(ofSize: 11, weight: .regular), lines: 1, color: .black.withAlphaComponent(0.8))
        audioView.addSubview(lblSubtitle)
        lblSubtitle.snp.makeConstraints { make in
            make.left.equalTo(imgAvatar.snp.right).offset(16)
            make.centerY.equalToSuperview().offset(8)
            make.right.equalTo(self.btnL.snp.left).offset(-12)
        }
        self.audioSubtitle = lblSubtitle
    }
}

extension QuranBribesRootView {
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.isBookVisible = false
        self.expendedAudioView.isHidden = false
    }
    
    @objc func cancelAudio(){
        self.audioView?.isHidden = true
        self.selectedIndex = -1
        
        // Only cancel downloads if there are active downloads
        if !downloadTasks.isEmpty || !downloadingIndexes.isEmpty {
            for (index, task) in downloadTasks {
                task.cancel()
                downloadingIndexes.remove(index)
            }
            downloadTasks.removeAll()
        }
        
        // Safely reload table view
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let tableView = self.tableView, tableView.window != nil else { return }
            tableView.reloadData()
        }
        
        self.delegate?.stopAudio()
        MainBean.shared.needStopFirebase = true
    }
    
    @objc func playStopAudio(){
        guard selectedIndex >= 0 && selectedIndex < bribesList.count else {
            return
        }
        
        audioIsPlay = !audioIsPlay
        self.delegate?.stopPlayAudio(state: audioIsPlay)
        
        let indexPath = IndexPath(row: self.selectedIndex, section: 0)
        guard let cell = self.tableView.cellForRow(at: indexPath) as? QuranBribesCell else {
            return
        }
        
        cell.playBtn.setImage(UIImage(named: audioIsPlay ? "ic_pause_dark" : "ic_play"), for: .normal)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    @objc func previousAudioCollapsed() {
        print("Collapsed: Previous audio button tapped")
        navigateToAudioFromCollapsed(direction: -1)
    }
    
    @objc func nextAudioCollapsed() {
        print("Collapsed: Next audio button tapped")
        navigateToAudioFromCollapsed(direction: 1)
    }
    
    private func navigateToAudioFromCollapsed(direction: Int) {
        // Get downloaded audio indexes
        let downloadedIndexes = getDownloadedAudioIndexes()
        
        guard !downloadedIndexes.isEmpty else {
            // No downloaded audios
            return
        }
        
        var currentIndex = -1
        if let currentSelectedIndex = downloadedIndexes.firstIndex(of: selectedIndex) {
            currentIndex = currentSelectedIndex
        } else {
            // If current selection is not in downloaded list, start from beginning or end
            currentIndex = direction > 0 ? -1 : downloadedIndexes.count
        }
        
        let nextIndex = currentIndex + direction
        
        if nextIndex >= 0 && nextIndex < downloadedIndexes.count {
            let targetAudioIndex = downloadedIndexes[nextIndex]
            selectAndPlayAudioFromCollapsed(at: targetAudioIndex)
        }
    }
    
    private func selectAndPlayAudioFromCollapsed(at index: Int) {
        guard index >= 0 && index < bribesList.count else { return }
        
        // Update selected index
        selectedIndex = index
        
        // Update UI
        updateCollapsedNavigationButtonsState()
        
        // Get the local file path for downloaded audio
        let item = bribesList[index]
        let myURL = item.file_url ?? ""
        
        if let audioUrl = URL(string: myURL) {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            // Set audioURL property for use in other methods
            audioURL = destinationUrl.absoluteString
            
            // Play the audio with local file path
            delegate?.selectedAudio(index: index, destination: audioURL)
        } else {
            // Fallback to original URL if local file not found
            delegate?.selectedAudio(index: index, destination: item.file_url ?? "")
        }
        
        // Update audio view and table
        setItemAudioView()
        
        // Reload table view to update selection
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    @objc func needDownload(sender:UIButton) {
        let index = sender.tag
        
        guard index >= 0 && index < bribesList.count else {
            return
        }
        
        if downloadingIndexes.contains(index) {
            cancelDownload(at: index)
            return
        }
        
        
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at:indexPath ) as? QuranBribesCell {
            print("Starting download progress for index: \(index)")
            cell.downloadBtn.isEnabled = true
            cell.downloadBtn.isHidden = false
            cell.downloadImg.isHidden = true
            
            cell.showDownloadProgress()
            
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                cell.updateDownloadProgress(0.0)
                print("Root: Forced 0% display for index: \(index)")
            }
        }
        
        downloadingIndexes.insert(index)
        
        self.downloadFileAtIndex(index: index)
    }
    
    func checkIsDownloaded(index:Int)->Bool {
        guard index >= 0 && index < bribesList.count else {
            return false
        }
        
        let myURL = self.bribesList[index].file_url ?? ""
        
        if let audioUrl = URL(string: myURL) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            audioURL = destinationUrl.absoluteString
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                return true
            }
        }
        return false
    }
    
    func downloadFileAtIndex(index:Int) {
        guard index >= 0 && index < bribesList.count else {
            downloadingIndexes.remove(index)
            return
        }
        
        let myURL = self.bribesList[index].file_url ?? ""
        
        if let audioUrl = URL(string: myURL) {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.downloadingIndexes.remove(index)
                    self.updateDownloadedCell(index: index)
                }
            } else {
                
                downloadTasks[index]?.cancel()
                
                let downloadTask = URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                    
                    DispatchQueue.main.async { [weak self] in
                        // Remove from downloading set
                        guard let self = self else { return }
                        self.downloadingIndexes.remove(index)
                        self.downloadTasks.removeValue(forKey: index)
                    }
                    
                    guard let location = location, error == nil else { 
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self, let tableView = self.tableView else { return }
                            let indexPath = IndexPath(row: index, section: 0)
                            if let cell = tableView.cellForRow(at: indexPath) as? QuranBribesCell {
                                cell.showDownloadButton()
                                cell.downloadBtn.isEnabled = true
                            }
                        }
                        return 
                    }
                    do {
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        
                        self.audioURL = destinationUrl.absoluteString
                        
                        self.delegate?.selectedAudio(index: index, destination: self.audioURL)
                        self.updateDownloadedCell(index: index)
                    } catch {
                        DispatchQueue.main.async { [weak self] in
                            guard let self = self, let tableView = self.tableView else { return }
                            let indexPath = IndexPath(row: index, section: 0)
                            if let cell = tableView.cellForRow(at: indexPath) as? QuranBribesCell {
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
                        guard let strongSelf = self else { return }
                        if strongSelf.downloadingIndexes.contains(index) {
                            let indexPath = IndexPath(row: index, section: 0)
                            if let cell = strongSelf.tableView.cellForRow(at: indexPath) as? QuranBribesCell {
                                cell.updateDownloadProgress(progressValue)
                            }
                        }
                    }
                }
                
                objc_setAssociatedObject(downloadTask, "progressObservation", observation, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                
                downloadTask.resume()
            }
        }
    }
    
    func updateDownloadedCell(index:Int) {
        guard index >= 0 && index < bribesList.count else {
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let tableView = self.tableView else { return }
            self.selectedIndex = index
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? QuranBribesCell {
                cell.hideDownloadProgress()
            }
            self.setItemAudioView()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func cancelDownload(at index: Int) {
        // Check if the index is valid
        guard index >= 0 && index < bribesList.count else {
            return
        }
        
        downloadingIndexes.remove(index)
        
        if let task = downloadTasks[index] {
            task.cancel()
            downloadTasks.removeValue(forKey: index)
        }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let tableView = self.tableView else { return }
            // Check if the tableView is still in the view hierarchy
            guard tableView.window != nil else { return }
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) as? QuranBribesCell {
                cell.hideDownloadProgress()
                cell.downloadBtn.isEnabled = true
                cell.downloadImg.image = UIImage(named: "ic_download")?.withRenderingMode(.alwaysTemplate)
                cell.downloadImg.tintColor = UIColor(named: "bgYellow")
            }
        }
    }
    
    func cancelAllDownloads() {
        guard !downloadTasks.isEmpty || !downloadingIndexes.isEmpty else {
            return
        }
        
        for (_, task) in downloadTasks {
            task.cancel()
        }
        
        downloadTasks.removeAll()
        downloadingIndexes.removeAll()
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let tableView = self.tableView else { return }
            // Only reload if the view is still in the window hierarchy
            if tableView.window != nil {
                tableView.reloadData()
            }
        }
    }
    
    func cleanupDownloads() {
        // Safely cleanup without forcing UI updates
        for (_, task) in downloadTasks {
            task.cancel()
        }
        downloadTasks.removeAll()
        downloadingIndexes.removeAll()
    }
}

extension QuranBribesRootView:UITableViewDataSource, UITableViewDelegate{
   
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bribesList.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuranBribesCell.className
        ) as? QuranBribesCell else { return UITableViewCell() }
        cell.setElements(item: bribesList[indexPath.row], index: indexPath.row)
        cell.playBtn.setImage(UIImage(named: !audioIsPlay ? "ic_pause_dark" : "ic_play"), for: .normal)
        cell.playBtn.addTarget(self, action: #selector(playStopAudio), for: .touchUpInside)
        
        cell.downloadBtn.removeTarget(nil, action: nil, for: .allEvents)
        cell.downloadBtn.tag = indexPath.row
        cell.downloadBtn.addTarget(self, action: #selector(needDownload(sender:)), for: .touchUpInside)

        let isDownloading = downloadingIndexes.contains(indexPath.row)
        
        if isDownloading {
            cell.downloadBtn.isEnabled = true
            cell.downloadBtn.isHidden = false
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
        
        if indexPath.row != selectedIndex {
            cell.viewBG.backgroundColor = .clear
            cell.downloadImg.isHidden = false
            cell.downloadImg.tintColor = UIColor(named: "bgYellow")
            cell.playBtn.isHidden = true
            cell.lblOrder.isHidden = false
            cell.lblTime.textColor = .white
            cell.lblTittle.textColor = .white
            cell.lblSubtittle.textColor = .white.withAlphaComponent(0.8)
        }else{
            cell.viewBG.backgroundColor = UIColor(named: "bgYellow")
            cell.downloadImg.tintColor = UIColor(named: "bgMain")
            cell.playBtn.isHidden = false
            cell.lblOrder.isHidden = true
            cell.lblTime.textColor = .black.withAlphaComponent(0.9)
            cell.lblTittle.textColor = .black.withAlphaComponent(0.9)
            cell.lblSubtittle.textColor = .black.withAlphaComponent(0.7)
        }
        
        if isDownloading {
            cell.downloadImg.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard indexPath.row >= 0 && indexPath.row < bribesList.count else {
            return
        }
        
        guard let cell = tableView.cellForRow(at: indexPath) as? QuranBribesCell else { return }
        if downloadingIndexes.contains(indexPath.row) {
            cancelDownload(at: indexPath.row)
            return
        }
        
        if checkIsDownloaded(index: indexPath.row) {
            self.selectedIndex = indexPath.row
            
            cell.viewBG.backgroundColor = UIColor(named: "bgYellow")
            cell.playBtn.isHidden = false
            cell.lblOrder.isHidden = true
            cell.lblTime.textColor = .black.withAlphaComponent(0.9)
            cell.lblTittle.textColor = .black.withAlphaComponent(0.9)
            cell.lblSubtittle.textColor = .black.withAlphaComponent(0.7)
            
            self.delegate?.selectedAudio(index: indexPath.row, destination: self.audioURL)
            cell.downloadImg.isHidden = false
            cell.showDownloadButton()
            cell.downloadImg.image = UIImage(named: "ic_check")?.withRenderingMode(.alwaysTemplate)
            cell.downloadImg.tintColor = UIColor(named: "bgMain")
            cell.downloadBtn.isEnabled = false
            
            self.setItemAudioView()
            
            tableView.reloadData()
            
        } else {
            downloadingIndexes.insert(indexPath.row)
            cell.downloadImg.isHidden = true
            cell.showDownloadProgress()
            
            DispatchQueue.main.async { [weak self] in
                guard self != nil else { return }
                cell.updateDownloadProgress(0.0)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if cell.progressView.percentageLabel.text != "0%" {
                    cell.updateDownloadProgress(0.0)
                }
            }
            
            self.downloadFileAtIndex(index: indexPath.row)
        }
    }
    
    func setItemAudioView(){
        guard selectedIndex >= 0 && selectedIndex < bribesList.count else {
            audioView.isHidden = true
            return
        }
        
        let item = self.bribesList[self.selectedIndex]
        self.audioTittle.text = item.name?.replacingOccurrences(of: "^", with: "'")
        let count:String = String(item.verses_count ?? 0)
        let placeType = Configs().chekMakOrMad(placeType: item.place_type ?? "")
        self.audioSubtitle.text = "\(placeType)\(count) oyatdan iborat"
        self.audioView.isHidden = false
        
        // Update navigation buttons state for collapsed view
        updateCollapsedNavigationButtonsState()
        
        // Update navigation buttons state in expanded view  
        if expendedAudioView != nil && !expendedAudioView.isHidden {
            updateNavigationButtonsState()
        }
    }
    
    // Update navigation buttons for collapsed audio view
    private func updateCollapsedNavigationButtonsState() {
        let downloadedIndexes = getDownloadedAudioIndexesForCollapsed()
        
        guard !downloadedIndexes.isEmpty else {
            btnL.alpha = 0.3
            btnR.alpha = 0.3
            btnL.isEnabled = false
            btnR.isEnabled = false
            return
        }
        
        if let currentIndexInDownloaded = downloadedIndexes.firstIndex(of: selectedIndex) {
            // Enable/disable previous button - always set alpha to 1.0 when enabled
            if currentIndexInDownloaded > 0 {
                btnL.alpha = 1.0
                btnL.isEnabled = true
            } else {
                btnL.alpha = 0.3
                btnL.isEnabled = false
            }
            
            // Enable/disable next button - always set alpha to 1.0 when enabled
            if currentIndexInDownloaded < downloadedIndexes.count - 1 {
                btnR.alpha = 1.0
                btnR.isEnabled = true
            } else {
                btnR.alpha = 0.3
                btnR.isEnabled = false
            }
        } else {
            // Current selection is not downloaded, enable both if there are downloaded audios
            btnL.alpha = downloadedIndexes.count > 0 ? 1.0 : 0.3
            btnR.alpha = downloadedIndexes.count > 0 ? 1.0 : 0.3
            btnL.isEnabled = downloadedIndexes.count > 0
            btnR.isEnabled = downloadedIndexes.count > 0
        }
    }
    
    // Helper method to get downloaded audio indexes (used by collapsed navigation)
    private func getDownloadedAudioIndexesForCollapsed() -> [Int] {
        var downloadedIndexes: [Int] = []
        
        for i in 0..<bribesList.count {
            if checkIsDownloaded(index: i) {
                downloadedIndexes.append(i)
            }
        }
        
        return downloadedIndexes
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at:indexPath ) as? QuranBribesCell else {return}
        cell.viewBG.backgroundColor = .clear
        cell.playBtn.isHidden = true
        cell.lblOrder.isHidden = false
        cell.lblTime.textColor = .white
        cell.lblTittle.textColor = .white
        cell.lblSubtittle.textColor = .white.withAlphaComponent(0.8)
        if checkIsDownloaded(index: indexPath.row) {
            cell.downloadImg.image = UIImage(named: "ic_check")
        } else {
            cell.downloadImg.image = UIImage(named: "ic_download")
        }
    }
}


extension QuranBribesRootView {
    
    func setUpExpendview(){
        let window = UIApplication.shared.keyWindow!
        let exView = UIView(frame: window.bounds)
        exView.backgroundColor = UIColor(named: "bgMain")
        exView.isHidden = true
        window.addSubview(exView)
        self.expendedAudioView = exView
        
        let btnExC = UIButton()
        btnExC.setImage(UIImage(named: "ic_cancel"), for: .normal)
        btnExC.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btnExC.addTarget(self, action: #selector(removeExpendView), for: .touchUpInside)
        self.expendedAudioView.addSubview(btnExC)
        btnExC.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(biometryType == .face ? 40 : 20)
            make.width.height.equalTo(50)
        }
        self.exBtnCancel = btnExC
        
        let btnExBook = UIButton()
        btnExBook.setImage(UIImage(named: "ic_book")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnExBook.tintColor = .white
        btnExBook.imageEdgeInsets = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
        btnExBook.addTarget(self, action: #selector(openBookView), for: .touchUpInside)
        self.expendedAudioView.addSubview(btnExBook)
        btnExBook.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(biometryType == .face ? 40 : 20)
            make.width.height.equalTo(50)
        }
        
        let navTitle = Label(font: UIFont.systemFont(ofSize: 18, weight: .semibold), lines: 2, color: .white, text: "Fotiha")
        navTitle.textAlignment = .center
        self.expendedAudioView.addSubview(navTitle)
        navTitle.snp.makeConstraints { make in
            make.left.equalTo(btnExC.snp.right).offset(16)
            make.right.equalTo(btnExBook.snp.left).offset(-16)
            make.centerY.equalTo(btnExC.snp.centerY)
        }
        
        
        self.exTitle = navTitle
        self.exBtnBook = btnExBook
        self.setExpendViewItems()
        self.setQuranImage()
        self.setAudioBody()
        
        // Initialize navigation buttons state
        updateNavigationButtonsState()
    }
    
    func setAudioBody(){
        let exBody = UIView()
        self.expendedAudioView.addSubview(exBody)
        exBody.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.exBtnCancel.snp.bottom).offset(20)
            make.bottom.equalTo(self.exBtnPlayStop.snp.top).offset(-20)
        }
        self.exBodyView = exBody
        
        let imgLogo = UIImageView()
        imgLogo.contentMode = .scaleAspectFill
        imgLogo.image = UIImage(named: "ic_logo_audio")
        self.exBodyView.addSubview(imgLogo)
        imgLogo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(UIScreen.main.bounds.height*0.08)
            make.width.equalToSuperview().multipliedBy(0.72)
            make.height.equalTo(imgLogo.snp.width)
            make.centerX.equalToSuperview()
        }
        self.exLogoImg = imgLogo
        
        let slider = UISlider()
        slider.backgroundColor = .clear
        slider.thumbTintColor = .white
        slider.tintColor = .white
        slider.value = 0.0
        self.exBodyView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(self.exBodyView.snp.bottom).offset(-20)
        }
        self.exSlider = slider
        
        let time = Label(font: UIFont.systemFont(ofSize: 10, weight: .regular), lines: 1, color: .white, text: "03:50")
        time.textAlignment = .right
        self.exBodyView.addSubview(time)
        time.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(self.exSlider.snp.bottom).offset(5)
        }
        self.exAudioTime = time
        
        let subtitle = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .white, text: "Makkiy, 7 oyat iborat")
        subtitle.textAlignment = .left
        self.exBodyView.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(self.exSlider.snp.top).offset(-24)
        }
        self.exAudioSubtitle = subtitle
        
        let title = Label(font: UIFont.systemFont(ofSize: 24, weight: .semibold), lines: 1, color: .white, text: "Fotiha")
        title.textAlignment = .left
        self.exBodyView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.bottom.equalTo(self.exAudioSubtitle.snp.top).offset(-8)
        }
        self.exAudioTittle = title

    }
    
    func setQuranImage(){
        
        let pdfView = UIView()
        pdfView.layer.masksToBounds = true
        pdfView.backgroundColor = UIColor(named: "bgLightYellow")
        pdfView.layer.cornerRadius = 16
        pdfView.isHidden = true
        self.expendedAudioView.addSubview(pdfView)
        pdfView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.exBtnCancel.snp.bottom).offset(16)
            make.bottom.equalTo(self.exBtnPlayStop.snp.top).offset(-16)
        }
        self.pdfView = pdfView
        
        let height:CGFloat = (biometryType == .face ? 40 : 20) + 200
        let cellWidth: CGFloat = UIScreen.main.bounds.width - 32
        let cellHeight: CGFloat = UIScreen.main.bounds.height-height
        lazy var collectionViewLayout: UICollectionViewFlowLayout = {
            let layout = UPCarouselFlowLayout()
            layout.scrollDirection = .horizontal
            layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
            layout.spacingMode = .fixed(spacing: 16)
            layout.sideItemScale = 0.95
            return layout
        }()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(named: "bgLightYellow")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(QuranBribesImgCell.self, forCellWithReuseIdentifier: QuranBribesImgCell.className)
        collectionView.isHidden = true
        self.pdfView.addSubview(collectionView)
        collectionView.snp.makeConstraints({$0.edges.equalToSuperview()})
        self.imgCollectionView = collectionView
        
    }
    
    func setExpendViewItems() {
        let btnPS = UIButton()
        btnPS.setImage(UIImage(named: "ic_audio_white_stop"), for: .normal)
        btnPS.imageView?.contentMode = .scaleAspectFill
        btnPS.addTarget(self, action: #selector(playStopAudio), for: .touchUpInside)
        self.expendedAudioView.addSubview(btnPS)
        btnPS.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(biometryType == .face ? -40 : -20)
            make.height.width.equalTo(80)
        }
        self.exBtnPlayStop = btnPS
        
        let btnL = UIButton()
        btnL.setImage(UIImage(named: "ic_audio_left")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnL.imageView?.tintColor = .white
        btnL.alpha = 0.3
        btnL.imageView?.contentMode = .scaleAspectFill
        btnL.addTarget(self, action: #selector(previousAudio), for: .touchUpInside)
        self.expendedAudioView.addSubview(btnL)
        btnL.snp.makeConstraints { make in
            make.right.equalTo(self.exBtnPlayStop.snp.left).offset(-35)
            make.centerY.equalTo(self.exBtnPlayStop.snp.centerY)
            make.height.width.equalTo(40)
        }
        self.exBtnL = btnL
        
        let btnR = UIButton()
        btnR.setImage(UIImage(named: "ic_audio_right")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnR.imageView?.tintColor = .white
        btnR.alpha = 0.3
        btnR.imageView?.contentMode = .scaleAspectFill
        btnR.addTarget(self, action: #selector(nextAudio), for: .touchUpInside)
        self.expendedAudioView.addSubview(btnR)
        btnR.snp.makeConstraints { make in
            make.left.equalTo(self.exBtnPlayStop.snp.right).offset(35)
            make.centerY.equalTo(self.exBtnPlayStop.snp.centerY)
            make.height.width.equalTo(40)
        }
        self.exBtnR = btnR
    }
    
    @objc func removeExpendView(){
        self.pdfView.isHidden = true
        self.imgCollectionView.isHidden = true
        self.exBodyView.isHidden = false
        self.expendedAudioView.isHidden = true
    }
    
    @objc func openBookView(){
        self.isBookVisible = !self.isBookVisible
        if isBookVisible {
            self.pdfView.isHidden = false
            self.imgCollectionView.isHidden = false
            self.exBodyView.isHidden = true
        }else{
            self.pdfView.isHidden = true
            self.imgCollectionView.isHidden = true
            self.exBodyView.isHidden = false
        }
    }
    
    @objc func previousAudio() {
        print("Expanded: Previous audio button tapped")
        navigateToAudio(direction: -1)
    }
    
    @objc func nextAudio() {
        print("Expanded: Next audio button tapped")
        navigateToAudio(direction: 1)
    }
    
    private func navigateToAudio(direction: Int) {
        // Get downloaded audio indexes
        let downloadedIndexes = getDownloadedAudioIndexes()
        
        guard !downloadedIndexes.isEmpty else {
            print("No downloaded audios found")
            return
        }
        
        var currentIndex = -1
        if let currentSelectedIndex = downloadedIndexes.firstIndex(of: selectedIndex) {
            currentIndex = currentSelectedIndex
            print("Found current index in downloaded list: \(currentIndex)")
        } else {
            // If current selection is not in downloaded list, start from beginning or end
            currentIndex = direction > 0 ? -1 : downloadedIndexes.count
            print("Current selection not in downloaded list, starting from: \(currentIndex)")
        }
        
        let nextIndex = currentIndex + direction
        print("Next index: \(nextIndex)")
        
        if nextIndex >= 0 && nextIndex < downloadedIndexes.count {
            let targetAudioIndex = downloadedIndexes[nextIndex]
            print("Navigating to audio at index: \(targetAudioIndex)")
            selectAndPlayAudio(at: targetAudioIndex)
        } else {
            print("Next index out of bounds")
        }
    }
    
    private func getDownloadedAudioIndexes() -> [Int] {
        var downloadedIndexes: [Int] = []
        
        for i in 0..<bribesList.count {
            if checkIsDownloaded(index: i) {
                downloadedIndexes.append(i)
            }
        }
        
        return downloadedIndexes
    }
    
    private func selectAndPlayAudio(at index: Int) {
        guard index >= 0 && index < bribesList.count else {
            print("Invalid index: \(index)")
            return
        }
        
        print("Selecting and playing audio at index: \(index)")
        
        // Save current playing state
        let wasPlaying = audioIsPlay
        
        // Update selected index
        selectedIndex = index
        
        // Update UI
        updateNavigationButtonsState()
        updateAudioInfo(for: bribesList[index])
        
        // Reload table view to update selection
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        
        // Get the local file path for downloaded audio
        let item = bribesList[index]
        let myURL = item.file_url ?? ""
        
        print("Audio URL: \(myURL)")
        
        if let audioUrl = URL(string: myURL) {
            let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            
            print("Local file path: \(destinationUrl.absoluteString)")
            
            // Play the audio with local file path
            delegate?.selectedAudio(index: index, destination: destinationUrl.absoluteString)
            
            // If was playing, continue playing the new audio
            if wasPlaying {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    self?.delegate?.stopPlayAudio(state: true)
                }
            }
            
        } else {
            print("Failed to create URL from: \(myURL)")
            // Fallback to original URL if local file not found
            delegate?.selectedAudio(index: index, destination: item.file_url ?? "")
        }
    }
    
    func updateNavigationButtonsState() {
        let downloadedIndexes = getDownloadedAudioIndexes()
        
        guard !downloadedIndexes.isEmpty else {
            exBtnL.alpha = 0.3
            exBtnR.alpha = 0.3
            exBtnL.isEnabled = false
            exBtnR.isEnabled = false
            return
        }
        
        if let currentIndexInDownloaded = downloadedIndexes.firstIndex(of: selectedIndex) {
            // Enable/disable previous button - always set alpha to 1.0 when enabled
            if currentIndexInDownloaded > 0 {
                exBtnL.alpha = 1.0
                exBtnL.isEnabled = true
            } else {
                exBtnL.alpha = 0.3
                exBtnL.isEnabled = false
            }
            
            // Enable/disable next button - always set alpha to 1.0 when enabled
            if currentIndexInDownloaded < downloadedIndexes.count - 1 {
                exBtnR.alpha = 1.0
                exBtnR.isEnabled = true
            } else {
                exBtnR.alpha = 0.3
                exBtnR.isEnabled = false
            }
        } else {
            // Current selection is not downloaded, enable both if there are downloaded audios
            exBtnL.alpha = downloadedIndexes.count > 0 ? 1.0 : 0.3
            exBtnR.alpha = downloadedIndexes.count > 0 ? 1.0 : 0.3
            exBtnL.isEnabled = downloadedIndexes.count > 0
            exBtnR.isEnabled = downloadedIndexes.count > 0
        }
    }
    
    private func updateAudioInfo(for item: MediasFiles) {
        // Update expanded view titles
        exTitle.text = item.name?.replacingOccurrences(of: "^", with: "'") ?? "Unknown"
        exAudioTittle.text = item.name?.replacingOccurrences(of: "^", with: "'") ?? "Unknown"
        
        let count: String = String(item.verses_count ?? 0)
        let placeType = Configs().chekMakOrMad(placeType: item.place_type ?? "")
        exAudioSubtitle.text = "\(placeType)\(count) oyatdan iborat"
        
        // Update collapsed audio view if needed
        if !audioView.isHidden {
            audioTittle?.text = item.name?.replacingOccurrences(of: "^", with: "'") ?? "Unknown"
            audioSubtitle?.text = "\(placeType)\(count) oyatdan iborat"
            
            // Update collapsed navigation buttons through main class method
            updateCollapsedNavigationButtonsState()
        }
    }
}

extension QuranBribesRootView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quranImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QuranBribesImgCell.className, for: indexPath) as? QuranBribesImgCell else { return UICollectionViewCell() }
        cell.itemIcon.image = self.quranImages[indexPath.row]
        return cell
    }
    
}
