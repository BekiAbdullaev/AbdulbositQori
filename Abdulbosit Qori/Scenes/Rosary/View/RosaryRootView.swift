//
//  RosaryRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/5/23.
//

import Foundation
import UIKit
import MyLibrary

protocol RosaryIxRespoder:AnyObject {
    func selectedAudio(index:Int, destination:String)
}

class RosaryRootView: NiblessView {
    
    // MARK: - Outlets
    weak var tableView:UITableView!
    weak var delegate:RosaryIxRespoder?
    var selectedIndex = -1
    var selectedCounterIndex = -1
    private var audioURL = ""
    var userDefaults = UserDefaults.standard
   
    weak var bottomView:UIView!
    weak var btnRefRosary:UIButton!
    weak var btnVoice:UIButton!
    weak var btnInfinity:UIButton!
    weak var lblPartCount:Label!
    weak var lblCunter:Label!
    weak var lblTotalCount:Label!
    weak var imgPlus:UIImageView!
    var tasbehs = [MediasFiles](){
        didSet {
            tableView.reloadData()
        }
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        self.setupBottom()
        self.setTableView()
    }
    
    private func setTableView(){
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(RosaryCell.self, forCellReuseIdentifier: RosaryCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.rowHeight = 62
        addSubview(tbView)
        tbView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.bottomView.snp.top)
        }
        self.tableView = tbView
    }
    
    
    private func setupBottom() {
        
        let bottomView = UIView()
        bottomView.layer.cornerRadius = 12
        bottomView.backgroundColor =  UIColor(named: "bgYellow")
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(UIScreen.main.bounds.height*0.45)
        }
        self.bottomView = bottomView
        
        let headerView = UIView()
        self.bottomView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(76)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor(named: "bgMain")?.withAlphaComponent(0.1)
        headerView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        
        let btnRef = UIButton()
        btnRef.setImage(UIImage(named: "ic_refresh")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnRef.tintColor = .black
        btnRef.imageView?.contentMode = .scaleAspectFit
        headerView.addSubview(btnRef)
        btnRef.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.btnRefRosary = btnRef
        
        let btnVoi = UIButton()
        btnVoi.setImage(UIImage(named: "ic_max_volume")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnVoi.tintColor = .black
        btnVoi.imageView?.contentMode = .scaleAspectFit
        headerView.addSubview(btnVoi)
        btnVoi.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.btnVoice = btnVoi
        
        let btnInf = UIButton()
        btnInf.setImage(UIImage(named: "ic_infinity")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnInf.tintColor = .black
        btnInf.imageView?.contentMode = .scaleAspectFit
        headerView.addSubview(btnInf)
        btnInf.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(self.btnVoice.snp.left).offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.btnInfinity = btnInf
        
        let partCount = Label(font: UIFont.systemFont(ofSize: 36, weight: .semibold), lines: 1, color: .black, text: "0")
        partCount.textAlignment = .center
        headerView.addSubview(partCount)
        partCount.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        self.lblPartCount = partCount
        
        let counter = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .black, text: "/00")
        counter.textAlignment = .center
        headerView.addSubview(counter)
        counter.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(20)
            make.centerY.equalToSuperview().offset(10)
        }
        self.lblCunter = counter
        
        let total = Label(font: UIFont.systemFont(ofSize: 20, weight: .medium), lines: 1, color: UIColor(named: "bgMain") ?? .black, text: "Jami: 0 ta")
        total.textAlignment = .center
        self.bottomView.addSubview(total)
        total.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-25)
        }
        self.lblTotalCount = total
        
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "ic_big_pluss")
        self.bottomView.addSubview(img)
        img.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.bottom.equalTo(self.lblTotalCount.snp.top).offset(-10)
            make.width.equalTo(img.snp.height)
           
        }
        self.imgPlus = img
    }
}

extension RosaryRootView {
    func checkIsDownloaded(index:Int)->Bool {
        var downloaded = false
        let myURL = tasbehs[index].file_url ?? ""
        if let audioUrl = URL(string: myURL) {
            let documentsDirectoryURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationUrl = documentsDirectoryURL.appendingPathComponent(audioUrl.lastPathComponent)
            audioURL = destinationUrl.absoluteString
            if FileManager.default.fileExists(atPath: destinationUrl.path) {
                downloaded = true
            }
        }
        return downloaded
    }
    
    func downloadFileAtIndex(index:Int) {
        let myURL = tasbehs[index].file_url ?? ""
        
        if let audioUrl = URL(string: myURL) {
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
                        self.updateDownloadedCell(index: index)
                        self.delegate?.selectedAudio(index: index, destination: self.audioURL)
                        print("File moved to documents folder")
                    } catch {
                        print(error)
                    }
                }.resume()
            }
        }
    }
    
    func updateDownloadedCell(index:Int) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
}

extension RosaryRootView:UITableViewDataSource, UITableViewDelegate{
   
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasbehs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RosaryCell.className
        ) as? RosaryCell else { return UITableViewCell() }
        let item = tasbehs[indexPath.row]
        
        cell.lblTittle.text = item.name?.replacingOccurrences(of: "^", with: "'").replacingOccurrences(of: "TASBEH ", with: "").capitalized
        if selectedCounterIndex != indexPath.row {
            cell.lblCount.text = ""
        }
        let counter:String = userDefaults.object(forKey: "counter\(indexPath.row)") as? String ?? ""
        if counter != ""{
            cell.lblCount.text = counter
        }
        
        if selectedIndex == indexPath.row {
            cell.viewBG.backgroundColor = UIColor(named: "bgYellow")
            cell.playBtn.setImage(UIImage(named: "ic_audio_stop"), for: .normal)
            cell.lblTittle.textColor = .black
            cell.lblCount.textColor = .black
        } else {
            cell.viewBG.backgroundColor = .clear
            cell.playBtn.setImage(UIImage(named: "ic_play_yellow"), for: .normal)
            cell.lblTittle.textColor = .white
            cell.lblCount.textColor = .white
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        self.selectedCounterIndex = indexPath.row
        let cell = tableView.cellForRow(at:indexPath ) as! RosaryCell
        cell.viewBG.backgroundColor = UIColor(named: "bgYellow")
        cell.playBtn.setImage(UIImage(named: "ic_audio_stop"), for: .normal)
        cell.lblTittle.textColor = .black
        cell.lblCount.textColor = .black
        if checkIsDownloaded(index: indexPath.row) {
            self.delegate?.selectedAudio(index: indexPath.row, destination: self.audioURL)
            cell.indicator.stopAnimating()
        } else {
            cell.indicator.startAnimating()
            self.downloadFileAtIndex(index: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath ) as! RosaryCell
        cell.viewBG.backgroundColor = .clear
        cell.playBtn.setImage(UIImage(named: "ic_play_yellow"), for: .normal)
        cell.lblTittle.textColor = .white
        cell.lblCount.textColor = .white
    }
}

