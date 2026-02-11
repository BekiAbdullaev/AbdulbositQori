//
//  PrayerRakatDetailCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/6/23.
//

import Foundation
import UIKit
import AVFoundation
import MyLibrary

class PrayerRakatDetailCell: UITableViewCell {
    
    // MARK: - Views
    weak var lblTittle:Label!
    weak var audioView:UIView!
    weak var btnAudio:UIButton!
    weak var audioSlider:UISlider!
    weak var lblSubtitle:Label!
    weak var btnMore:UIButton!
    weak var imgPrayer:UIImageView!
    weak var indicator:UIActivityIndicatorView!
    
    private var audioURL = ""
    var player:AVAudioPlayer?
    private var index = -1
    private var keyAudio = ""
    var isPlaying = false
   
        
    //MARK: - Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = false
        backgroundColor = .clear
        selectionStyle = .none
        setUI()
    }
    
    func setUI(){
        
        let title = Label(font: UIFont.systemFont(ofSize: 20, weight: .semibold), lines: 1, color: .black)
        self.contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        self.lblTittle = title
        
        let viewAudio = UIView()
        viewAudio.backgroundColor = UIColor(named: "bgMain")
        viewAudio.layer.cornerRadius = 27
        self.contentView.addSubview(viewAudio)
        viewAudio.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.lblTittle.snp.bottom).offset(16)
            make.height.equalTo(54)
        }
        self.audioView = viewAudio
        
        let btnA = UIButton()
        btnA.setImage(UIImage(named: "ic_light_play"), for: .normal)
        btnA.addTarget(self, action: #selector(audioPlayAtIndex(_:)), for: .touchUpInside)
        self.audioView.addSubview(btnA)
        btnA.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(7)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(42)
        }
        self.btnAudio = btnA
        
        let slider = UISlider()
        slider.backgroundColor = .clear
        slider.thumbTintColor = .white
        slider.tintColor = .white
        slider.value = 0.0
        self.audioView.addSubview(slider)
        slider.snp.makeConstraints { make in
            make.left.equalTo(self.btnAudio.snp.right).offset(16)
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
        self.audioSlider = slider
        
        let indicator = UIActivityIndicatorView(style: .white)
        self.audioView.addSubview(indicator)
        self.audioView.bringSubviewToFront(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.audioView.snp.right).offset(-6)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.indicator = indicator
        
        
        let stitle = Label(font: UIFont.systemFont(ofSize: 15, weight: .regular), lines: 0, color: .black)
        self.contentView.addSubview(stitle)
        stitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.audioView.snp.bottom).offset(16)
        }
        self.lblSubtitle = stitle
        
        let btn = UIButton()
        let btnAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16, weight: .medium),
              .foregroundColor: UIColor.black,
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]
        let attributeString = NSMutableAttributedString(string: "Batafsil ...", attributes: btnAttributes)
        btn.setAttributedTitle(attributeString, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        btn.setTitleColor(.black, for: .normal)
        self.contentView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalTo(self.lblSubtitle.snp.bottom).offset(12)
        }
        self.btnMore = btn
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        self.contentView.addSubview(img)
        img.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.btnMore.snp.bottom).offset(16)
            make.height.equalTo(192)
            make.bottom.equalToSuperview().offset(-12)
        }
        self.imgPrayer = img
    }
    
    func setItems(item:PrayerRakatModel?, index:Int, keyValue:String, isManRule:Bool) {
        self.index = index
        self.keyAudio = keyValue
        let allText = isManRule ? item?.subtitle ?? "" : item?.womenSubtitle ?? ""
        var attributedString = NSMutableAttributedString()
        attributedString = NSMutableAttributedString(string: allText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
        for item in PrayerRuleModel().attrWords {
            let range = (allText as NSString).range(of: item)
            attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black], range: range)
        }
        self.lblSubtitle.attributedText = String.setLineSpaceAttributed(attributedString: attributedString, space: 5)
        
        if (item?.title == "Azon" || item?.title == "Iqomat") && !isManRule {
            self.btnMore.isHidden = true
        }else{
            self.btnMore.isHidden = false
        }
       
        if !(item?.hasAudio ?? false) {
            self.audioView.isHidden = true
            self.lblSubtitle.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.equalTo(self.lblTittle.snp.bottom).offset(16)
            }
        } else {
            self.audioView.isHidden = false
            self.lblSubtitle.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.equalTo(self.audioView.snp.bottom).offset(16)
            }
        }
        if !(item?.hasImage ?? false) {
            self.imgPrayer.isHidden = true
            self.btnMore.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.top.equalTo(self.lblSubtitle.snp.bottom).offset(16)
                make.bottom.equalToSuperview().offset(-16)
            }
        } else {
            self.imgPrayer.isHidden = false
            self.btnMore.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(16)
                make.top.equalTo(self.lblSubtitle.snp.bottom).offset(16)
            }
        }
    }
    
    @objc func audioPlayAtIndex(_ sender:UIButton) {
        
        
        
//        if MainBean.shared.isPlayStarted {
//            
//             self.player?.stop()
//            print("Haluu0:\(MainBean.shared.isPlayStarted)")
//        } else {
//            
//            print("Haluu1:\(MainBean.shared.isPlayStarted)")
//            for item in MainBean.shared.namazs {
//                if self.keyAudio == item.key {
//                    self.playAudio(index: index, fileURL: item.file_url ?? "")
//                }
//            }
//        }
    }
}



extension PrayerRakatDetailCell:AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        MainBean.shared.isPlayStarted = false
    }
    
    func playAudio(index:Int, fileURL:String){
        
        if checkIsDownloaded(index: index, fileURL: fileURL) {
            
            guard let desURL = URL(string: audioURL) else {return}
            do {
                player = try AVAudioPlayer(contentsOf: desURL)
                player?.prepareToPlay()
                player?.delegate = self
                player?.play()
            } catch _ {
                player = nil
            }
        } else {
            downloadFileAtIndex(index: index, fileURL: fileURL)
        }
    }
    
    func checkIsDownloaded(index:Int, fileURL:String)->Bool {
        var downloaded = false
        if let audioUrl = URL(string: fileURL) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            audioURL = destinationUrl.absoluteString
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                downloaded = true
            }
        }
        return downloaded
    }
    
    func downloadFileAtIndex(index:Int, fileURL:String){
        
        if let audioUrl = URL(string: fileURL) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            print(destinationUrl)
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                print("The file already exists at path")
            } else {
                URLSession.shared.downloadTask(with: audioUrl) { location, response, error in
                    guard let location = location, error == nil else { return }
                    do {
                        try FileManager.default.moveItem(at: location, to: destinationUrl)
                        print("File moved to documents folder")
                        self.playAudio(index: index, fileURL: fileURL)
                    } catch {
                        print(error)
                    }
                }.resume()
            }
        }
    }
}
