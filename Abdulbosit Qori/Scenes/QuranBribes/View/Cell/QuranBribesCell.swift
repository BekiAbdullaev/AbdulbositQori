//
//  QuranBribesCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary

class QuranBribesCell: UITableViewCell {
    
    weak var viewBG:UIView!
    weak var playBtn:UIButton!
    weak var downloadBtn:UIButton!
    weak var downloadImg:UIImageView!
    weak var lblOrder:Label!
    weak var lblTittle:Label!
    weak var lblSubtittle:Label!
    weak var lblTime:Label!
    weak var progressView: CircularProgressView!
   
        
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
    
    func setElements(item:MediasFiles, index:Int){
        self.lblTittle.text = item.name?.replacingOccurrences(of: "^", with: "'")
        let count:String = String(item.verses_count ?? 0)
        let placeType = Configs().chekMakOrMad(placeType: item.place_type ?? "")
        self.lblSubtittle.text = "\(placeType)\(count) oyatdan iborat"
        self.lblOrder.text = index >= 9 ? "\(index+1)" : "0\(index+1)"
        let prefixTime = item.duration?.prefix(2)
        self.lblTime.text = prefixTime == "00" ? "\(String(item.duration?.dropFirst(3) ?? ""))" : "\(item.duration ?? "")"
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
        print("Cell: Updating progress to \(progress * 100)%")
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        progressView.isHidden = true
        progressView.resetProgress()
        downloadImg.isHidden = false
        downloadBtn.isEnabled = true
        downloadBtn.isHidden = false
    }
    
    func setItems(){
        let viewbg = UIView()
        viewbg.backgroundColor = .clear
        viewbg.layer.cornerRadius = 7
        self.contentView.addSubview(viewbg)
        viewbg.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(10)
        }
        self.viewBG = viewbg
        
        let order = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white)
        self.viewBG.addSubview(order)
        order.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        self.lblOrder = order
        
        let btnPlay = UIButton()
        btnPlay.isHidden = true
        btnPlay.setImage(UIImage(named: "ic_pause_dark"), for: .normal)
        self.viewBG.addSubview(btnPlay)
        btnPlay.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.playBtn = btnPlay
        
        let imgD = UIImageView()
        imgD.contentMode = .scaleAspectFill
        imgD.image = UIImage(named: "ic_download")?.withRenderingMode(.alwaysTemplate)
        self.viewBG.addSubview(imgD)
        imgD.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(20)
        }
        self.downloadImg = imgD
        
        let btnDow = UIButton()
        self.viewBG.addSubview(btnDow)
        btnDow.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.downloadBtn = btnDow
        
        let progressView = CircularProgressView()
        progressView.isHidden = true
        self.viewBG.addSubview(progressView)
        self.viewBG.bringSubviewToFront(progressView)
        progressView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(24)
            make.width.equalTo(24)
        }
        self.progressView = progressView
        
        let time = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white, text: "05:34")
        time.textAlignment = .right
        self.viewBG.addSubview(time)
        time.snp.makeConstraints { make in
            make.right.equalTo(self.downloadBtn.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
        self.lblTime = time
        
        let title = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 1, color: .white, text: "Fotaha")
        self.viewBG.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(self.playBtn.snp.right).offset(8)
            make.centerY.equalToSuperview().offset(-10)
            make.right.equalTo(self.lblTime.snp.left).offset(-10)
        }
        self.lblTittle = title
        
        let subtitle = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white.withAlphaComponent(0.8), text: "makkiy, 7 oyatdan iborat")
        self.viewBG.addSubview(subtitle)
        subtitle.snp.makeConstraints { make in
            make.left.equalTo(self.playBtn.snp.right).offset(8)
            make.centerY.equalToSuperview().offset(10)
            make.right.equalTo(self.lblTime.snp.left).offset(-10)
        }
        self.lblSubtittle = subtitle
    }
}

class CircularProgressView: UIView {
    
    private var progressLayer = CAShapeLayer()
    private var trackLayer = CAShapeLayer()
    var percentageLabel = UILabel()
    
    var progress: Float = 0 {
        didSet {
            updateProgress()
        }
    }
    
    var lineWidth: CGFloat = 2.0
    var progressColor: UIColor = UIColor(named: "bgYellow") ?? .systemYellow
    var trackColor: UIColor = UIColor.white.withAlphaComponent(0.3)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        
        percentageLabel.textAlignment = .center
        percentageLabel.font = UIFont.systemFont(ofSize: 8, weight: .medium)
        percentageLabel.textColor = .white
        percentageLabel.text = "0%"
        percentageLabel.isHidden = false
        addSubview(percentageLabel)
        
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if bounds != .zero {
            setupCircularPath()
        }
    }
    
    private func setupCircularPath() {
        trackLayer.removeFromSuperlayer()
        progressLayer.removeFromSuperlayer()
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        
        let circularPath = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: -CGFloat.pi / 2,
            endAngle: 1.5 * CGFloat.pi,
            clockwise: true
        )
        
        trackLayer.path = circularPath.cgPath
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = CGFloat(progress)
        layer.addSublayer(progressLayer)
        
        bringSubviewToFront(percentageLabel)
    }
    
    private func updateProgress() {
        let clampedProgress = max(0, min(1, progress))
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.progressLayer.strokeEnd = CGFloat(clampedProgress)
            
            let percentageText = Int(clampedProgress * 100)
            self.percentageLabel.text = "\(percentageText)%"
            
            self.percentageLabel.isHidden = false
        }
    }
    
    func setProgress(_ progress: Float, animated: Bool = true) {
        let clampedProgress = max(0, min(1, progress))
        
        if bounds == .zero {
            DispatchQueue.main.async { [weak self] in
                self?.setProgress(progress, animated: animated)
            }
            return
        }
        
        if animated && abs(self.progress - clampedProgress) > 0.001 {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = progressLayer.strokeEnd
            animation.toValue = clampedProgress
            animation.duration = 0.1
            animation.timingFunction = CAMediaTimingFunction(name: .linear)
            progressLayer.add(animation, forKey: "progressAnimation")
        }
        
        self.progress = clampedProgress
        
        if clampedProgress == 0.0 {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.progressLayer.strokeEnd = 0
                self.percentageLabel.text = "0%"
                self.percentageLabel.isHidden = false
            }
        }
    }
    
    func startDownload() {
        isHidden = false
        
        progressLayer.removeAllAnimations()
        
        progress = 0.0
        progressLayer.strokeEnd = 0
        percentageLabel.text = "0%"
        percentageLabel.isHidden = false
        
        if bounds != .zero {
            setupCircularPath()
            progressLayer.strokeEnd = 0
        } else {
            setNeedsLayout()
            layoutIfNeeded()
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if self.bounds != .zero {
                    self.setupCircularPath()
                    self.progressLayer.strokeEnd = 0
                }
                self.percentageLabel.text = "0%"
                self.percentageLabel.isHidden = false
            }
        }
        
    }
    
    func finishDownload() {
        setProgress(1.0, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.isHidden = true
            self?.progress = 0
            self?.percentageLabel.text = "0%"
        }
    }
    
    func resetProgress() {
        print("CircularProgressView: Resetting progress")
        progress = 0
        percentageLabel.text = "0%"
        percentageLabel.isHidden = false
        progressLayer.strokeEnd = 0
    }
}
