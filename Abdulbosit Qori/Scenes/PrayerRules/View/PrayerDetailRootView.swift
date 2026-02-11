//
//  PrayerDetailRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit
import MyLibrary

final class PrayerDetailRootView: UIView {
    // MARK: - Outlets
    weak var bgView:UIView!
    weak var tableView:UITableView!
    internal var itemOnClick:((Int)->Void)?
    internal var audioOnClick:((Int, String)->Void)?
    var section:Int = -1
    var row:Int = -1
    var isManRule:Bool = false
    var selectedIndex = -1
    var isPlay = false
   
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI() {
        clipsToBounds = true
        backgroundColor = UIColor(named: "bgMain")
        let view = UIView()
        view.backgroundColor = UIColor(named: "bgLightYellow")
        view.layer.cornerRadius = 16
        addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-8)
        }
        self.bgView = view
        self.setTableView()
    }
    
    private func setTableView(){
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(PrayerRakatDetailCell.self, forCellReuseIdentifier: PrayerRakatDetailCell.className)
        tbView.showsVerticalScrollIndicator = false
        self.bgView.addSubview(tbView)
        tbView.snp.makeConstraints({$0.edges.equalTo(self.bgView.snp.edges)})
        self.tableView = tbView
    }
}
extension PrayerDetailRootView:UITableViewDataSource, UITableViewDelegate{
   
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (self.section, self.row) {
        case (0,0):
            return PrayerRuleModel().bomdod2RakatSunnat.count
        case (0,1):
            return PrayerRuleModel().bomdod2RakatFarz.count
        case (1,0):
            return PrayerRuleModel().peshin4RakatSunnat.count
        case (1,1):
            return PrayerRuleModel().peshin4RakatFarz.count
        case (1,2):
            return PrayerRuleModel().peshin2RakatSunnat.count
        case (2,0):
            return PrayerRuleModel().asr4RakatFarz.count
        case (3,0):
            return PrayerRuleModel().shom3RakatFarz.count
        case (3,1):
            return PrayerRuleModel().shom2RakatSunnat.count
        case (4,0):
            return PrayerRuleModel().xufton4RakatFarz.count
        case (4,1):
            return PrayerRuleModel().xufton2RakatSunnat.count
        case (4,2):
            return PrayerRuleModel().xufton3RakatVitr.count
        case (5,0):
            return PrayerRuleModel().juma4RakatSunnat.count
        case (5,1):
            return PrayerRuleModel().juma2RakatFarz.count
        case (5,2):
            return PrayerRuleModel().juma4RakatSunnat.count
        case (6,0):
            return PrayerRuleModel().janozaNomozi.count
        case (_, _):
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrayerRakatDetailCell.className
        ) as? PrayerRakatDetailCell else { return UITableViewCell() }
        var item:PrayerRakatModel?
        switch (self.section, self.row) {
        case (0,0):
            item = PrayerRuleModel().bomdod2RakatSunnat[indexPath.row]
        case (0,1):
            item = PrayerRuleModel().bomdod2RakatFarz[indexPath.row]
        case (1,0):
            item = PrayerRuleModel().peshin4RakatSunnat[indexPath.row]
        case (1,1):
            item = PrayerRuleModel().peshin4RakatFarz[indexPath.row]
        case (1,2):
            item = PrayerRuleModel().peshin2RakatSunnat[indexPath.row]
        case (2,0):
            item = PrayerRuleModel().asr4RakatFarz[indexPath.row]
        case (3,0):
            item = PrayerRuleModel().shom3RakatFarz[indexPath.row]
        case (3,1):
            item = PrayerRuleModel().shom2RakatSunnat[indexPath.row]
        case (4,0):
            item = PrayerRuleModel().xufton4RakatFarz[indexPath.row]
        case (4,1):
            item = PrayerRuleModel().xufton2RakatSunnat[indexPath.row]
        case (4,2):
            item = PrayerRuleModel().xufton3RakatVitr[indexPath.row]
        case (5,0):
            item = PrayerRuleModel().juma4RakatSunnat[indexPath.row]
        case (5,1):
            item = PrayerRuleModel().juma2RakatFarz[indexPath.row]
        case (5,2):
            item = PrayerRuleModel().juma4RakatSunnat[indexPath.row]
        case (6,0):
            item = PrayerRuleModel().janozaNomozi[indexPath.row]
        case (_, _):
            print("")
        }
        cell.lblTittle.text = indexPath.row == 0 ? item?.title : ("\(indexPath.row). " + (item?.title ?? ""))
        cell.imgPrayer.image = isManRule ? UIImage(named: item?.imageMan ?? "") : UIImage(named: item?.imageWoman ?? "")
        cell.setItems(item: item,index: indexPath.row, keyValue: getAudioKey(index: indexPath.row), isManRule: isManRule)
        let maxAudio = MainBean.shared.maxAudioValue
        let currentAudio = MainBean.shared.currentAudioValue
        cell.audioSlider.maximumValue = (maxAudio.index == indexPath.row) ? maxAudio.value : 0.0
        cell.audioSlider.value = (currentAudio.index == indexPath.row) ? currentAudio.value : 0.0
        cell.btnMore.tag = indexPath.row
        cell.btnAudio.tag = indexPath.row
        cell.btnMore.addTarget(self, action: #selector(showMoreAtIndex(_:)), for: .touchUpInside)
        cell.btnAudio.addTarget(self, action: #selector(audioPlayAtIndex(_:)), for: .touchUpInside)
        if selectedIndex == indexPath.row {
            cell.btnAudio.setImage(UIImage(named: self.isPlay ? "ic_light_pause" : "ic_light_play"), for: .normal)
        }else {
            cell.btnAudio.setImage(UIImage(named: "ic_light_play"), for: .normal)
        }
        return cell
    }
    @objc func showMoreAtIndex(_ sender:UIButton) {
        let index = sender.tag
        self.itemOnClick!(index)
    }
    @objc func audioPlayAtIndex(_ sender:UIButton) {
        let index = sender.tag
        self.selectedIndex = index
        self.isPlay = !self.isPlay
        self.audioOnClick!(index, getAudioKey(index: index))
    }
    
    func getAudioKey(index:Int) -> String{
        switch (self.section, self.row) {
        case (0,0):
            return PrayerRuleModel().bomdod2RakatSunnat[index].audioKey
        case (0,1):
            return PrayerRuleModel().bomdod2RakatFarz[index].audioKey
        case (1,0):
            return PrayerRuleModel().peshin4RakatSunnat[index].audioKey
        case (1,1):
            return PrayerRuleModel().peshin4RakatFarz[index].audioKey
        case (1,2):
            return PrayerRuleModel().peshin2RakatSunnat[index].audioKey
        case (2,0):
            return PrayerRuleModel().asr4RakatFarz[index].audioKey
        case (3,0):
            return PrayerRuleModel().shom3RakatFarz[index].audioKey
        case (3,1):
            return PrayerRuleModel().shom2RakatSunnat[index].audioKey
        case (4,0):
            return PrayerRuleModel().xufton4RakatFarz[index].audioKey
        case (4,1):
            return PrayerRuleModel().xufton2RakatSunnat[index].audioKey
        case (4,2):
            return PrayerRuleModel().xufton3RakatVitr[index].audioKey
        case (5,0):
            return PrayerRuleModel().juma4RakatSunnat[index].audioKey
        case (5,1):
            return PrayerRuleModel().juma2RakatFarz[index].audioKey
        case (5,2):
            return PrayerRuleModel().juma4RakatSunnat[index].audioKey
        case (6,0):
            return PrayerRuleModel().janozaNomozi[index].audioKey
        case (_, _):
            return ""
        }
    }
}
