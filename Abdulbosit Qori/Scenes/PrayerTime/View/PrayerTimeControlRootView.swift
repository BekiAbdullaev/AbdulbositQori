//
//  PrayerTimeControlRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/11/23.
//

import Foundation
import UIKit
import MyLibrary

class PrayerTimeControlRootView: NiblessView {
    
    // MARK: - Outlets
    weak var topView:UIView!
    weak var tableView:UITableView!
    var selectedIndex = -1
    internal var OnClick:((PrayerTimeState)->Void)?
    internal var azonClicked:(()->Void)?
    var numberOfState = PrayerTimeModel().prayerSoundsList.count{
        didSet{
            topView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview().inset(16)
                make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
                make.height.equalTo(124)
            }
            tableView.reloadData()
        }
    }
    var isPlaying = false
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        self.setupTableView()
    }
    
    private func setupTableView() {
        let topView = UIView()
        topView.layer.cornerRadius = 12
        topView.backgroundColor =  UIColor(named: "bgYellow")
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.height.equalTo(180)
        }
        self.topView = topView
        
        let tbView = UITableView(frame: .zero, style: .plain)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.layer.cornerRadius = 12
        tbView.backgroundColor = UIColor(named: "bgYellow")
        tbView.register(PrayerTimeControlCell.self, forCellReuseIdentifier: PrayerTimeControlCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.isScrollEnabled = false
        tbView.rowHeight = 56
        self.topView.addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(6)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        self.tableView = tbView
    }
    @objc func azonBtnClicked(){
        self.isPlaying = !self.isPlaying
        self.tableView.reloadData()
        self.azonClicked!()
    }
}
    
extension PrayerTimeControlRootView:UITableViewDataSource, UITableViewDelegate{

    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfState
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrayerTimeControlCell.className
        ) as? PrayerTimeControlCell else { return UITableViewCell() }
        let item = PrayerTimeModel().prayerSoundsList[indexPath.row]
        cell.lblName.text = item.name
        cell.imgType.image = UIImage(named: item.image)?.withRenderingMode(.alwaysTemplate)
        cell.btnVoice.isHidden = !item.needPlay
        cell.btnVoice.addTarget(self, action: #selector(azonBtnClicked), for: .touchUpInside)
        if indexPath.row == selectedIndex {
            cell.viewBG.backgroundColor = UIColor(named: "bgMain")
            cell.lblName.textColor = .white
            cell.btnVoice.tintColor = .white
            cell.imgType.tintColor = .white
            cell.btnVoice.setImage(UIImage(named: isPlaying ? "ic_light_pause" : "ic_light_play"), for: .normal)
        } else {
            cell.viewBG.backgroundColor = .clear
            cell.lblName.textColor = .black
            cell.btnVoice.tintColor = UIColor(named: "bgMain")
            cell.imgType.tintColor = UIColor(named: "bgMain")
            cell.btnVoice.setImage(UIImage(named: isPlaying ? "ic_audio_stop" : "ic_audio_play"), for: .normal)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
        switch indexPath.row {
        case 0:
            self.OnClick!(.cilent)
        case 1:
            self.OnClick!(.vibration)
        case 2:
            self.OnClick!(.sound)
        default:
            print("")
        }
        let cell = tableView.cellForRow(at: indexPath) as! PrayerTimeControlCell
        cell.viewBG.backgroundColor = UIColor(named: "bgMain")
        cell.btnVoice.setImage(UIImage(named: "ic_light_play"), for: .normal)
        cell.lblName.textColor = .white
        cell.btnVoice.tintColor = .white
        cell.imgType.tintColor = .white
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PrayerTimeControlCell
        cell.viewBG.backgroundColor = .clear
        cell.lblName.textColor = .black
        cell.btnVoice.tintColor = UIColor(named: "bgMain")
        cell.btnVoice.setImage(UIImage(named: "ic_audio_play"), for: .normal)
        cell.imgType.tintColor = UIColor(named: "bgMain")
    }
}
