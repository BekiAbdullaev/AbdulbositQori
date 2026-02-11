//
//  QuranStudyCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary

class QuranStudyCell: UITableViewCell {
    
    // MARK: - Views
    weak var viewBG: UIView!
    weak var playBtn: UIButton!
    weak var downloadBtn: UIButton!
    weak var downloadImg: UIImageView!
    weak var lblOrder: Label!
    weak var lblTittle: Label!
    weak var lblTime: Label!
    weak var progressView: CircularProgressView!
   
    // MARK: - Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = false
        backgroundColor = .clear
        selectionStyle = .none
        setItems()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.isHidden = true
        progressView.resetProgress()
        downloadImg.isHidden = false
        downloadBtn.isEnabled = true
        downloadBtn.isHidden = false
        playBtn.isHidden = true
        lblOrder.isHidden = false
    }
    
    func showDownloadProgress() {
        downloadImg.isHidden = true
        progressView.isHidden = false
        progressView.setNeedsLayout()
        progressView.layoutIfNeeded()
        DispatchQueue.main.async { [weak self] in
            self?.progressView.startDownload()
            self?.progressView.setProgress(0.0, animated: false)
        }
    }
    
    func updateDownloadProgress(_ progress: Float) {
        DispatchQueue.main.async { [weak self] in
            self?.progressView.setProgress(progress, animated: true)
        }
    }
    
    func hideDownloadProgress() {
        progressView.finishDownload()
        downloadImg.isHidden = false
    }
    
    func showDownloadButton() {
        progressView.isHidden = true
        downloadImg.isHidden = false
    }
    
    func setItems() {
        let viewbg = UIView()
        viewbg.backgroundColor = .clear
        viewbg.layer.cornerRadius = 7
        self.contentView.addSubview(viewbg)
        viewbg.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(10)
        }
        self.viewBG = viewbg
        
        // Order number label
        let order = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white)
        self.viewBG.addSubview(order)
        order.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(24)
        }
        self.lblOrder = order
        
        // Play/Pause button (shown when selected)
        let btnPlay = UIButton()
        btnPlay.isHidden = true
        btnPlay.setImage(UIImage(named: "ic_play_yellow"), for: .normal)
        btnPlay.imageView?.contentMode = .scaleAspectFit
        self.viewBG.addSubview(btnPlay)
        btnPlay.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(40)
            make.width.equalTo(28)
        }
        self.playBtn = btnPlay
        
        // Download icon
        let imgD = UIImageView()
        imgD.contentMode = .scaleAspectFit
        imgD.image = UIImage(named: "ic_download")?.withRenderingMode(.alwaysTemplate)
        imgD.tintColor = UIColor(named: "bgYellow")
        self.viewBG.addSubview(imgD)
        imgD.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
        }
        self.downloadImg = imgD
        
        // Download button (invisible, covers download icon area)
        let btnDow = UIButton()
        self.viewBG.addSubview(btnDow)
        btnDow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.downloadBtn = btnDow
        
        // Circular progress view for download
        let circularProgress = CircularProgressView()
        circularProgress.isHidden = true
        self.viewBG.addSubview(circularProgress)
        self.viewBG.bringSubviewToFront(circularProgress)
        circularProgress.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        self.progressView = circularProgress
        
        // Duration label
        let time = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white.withAlphaComponent(0.8))
        time.textAlignment = .right
        self.viewBG.addSubview(time)
        time.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.downloadBtn.snp.left).offset(-12)
        }
        self.lblTime = time
        
        // Title label
        let title = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 1, color: .white, text: "")
        self.viewBG.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(self.playBtn.snp.right).offset(8)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.lblTime.snp.left).offset(-10)
        }
        self.lblTittle = title
    }
}
