//
//  PrayerInnerView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/5/23.
//

import Foundation
import UIKit
import MyLibrary

class PrayerInnerView: NiblessView {
    
    // MARK: - Outlets
    weak var topView:UIView!
    weak var prayerType:Label!
    weak var prayerTime:Label!
    weak var leftTime:Label!
    weak var btnRefresh:UIButton!
    weak var rotateImg:UIImageView!
    weak var bottomView:UIView!
    weak var tableView:UITableView!
    private var userDefaults = UserDefaults.standard
    internal var prayerTimeOnClick:((Int, PrayerTimeState)->Void)?
    internal var leftBtnOnClick:((Date)->Void)?
    internal var rightBtnOnClick:((Date)->Void)?
    var selectedIndex = Int() {
        didSet {
            tableView.reloadData()
        }
    }
    var selectedDate = Date()
    
    var dateList = [String]() {
        didSet {
            tableView.reloadData()
        }
    }
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        self.setTopView()
        self.setupTableView()
        dateList = [MainBean.shared.bomdodTime, MainBean.shared.quyoshTime, MainBean.shared.peshinTime, MainBean.shared.asrTime, MainBean.shared.shomTime, MainBean.shared.xuftonTime]
    
    }
    
    private func setTopView(){
        let topView = UIView()
        topView.backgroundColor = .clear
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height*0.29)
        }
        self.topView = topView
        
        let lblTime = Label(font: UIFont.systemFont(ofSize: 48, weight: .bold), lines: 1, color: .white, text: "17:39")
        lblTime.textAlignment = .center
        self.topView.addSubview(lblTime)
        lblTime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
        }
        self.prayerTime = lblTime
        
        let lblType = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .white, text: "Asr vaqti")
        lblType.textAlignment = .center
        self.topView.addSubview(lblType)
        lblType.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.prayerTime.snp.top)
        }
        self.prayerType = lblType
        
        let lblLeft = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .white, text: "00:00:00")
        lblLeft.textAlignment = .center
        self.topView.addSubview(lblLeft)
        lblLeft.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.prayerTime.snp.bottom)
        }
        self.leftTime = lblLeft
        
        let btnRefresh = UIButton()
        btnRefresh.setTitle("Tashkent, Uzbekistan", for: .normal)
        btnRefresh.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        self.topView.addSubview(btnRefresh)
        btnRefresh.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(20)
            make.top.equalTo(self.leftTime.snp.bottom).offset(8)
        }
        self.btnRefresh = btnRefresh
        
        let imgRotate = UIImageView()
        imgRotate.image = UIImage(named: "ic_refresh")
        imgRotate.contentMode = .scaleAspectFill
        self.topView.addSubview(imgRotate)
        imgRotate.snp.makeConstraints { make in
            make.centerY.equalTo( self.btnRefresh.snp.centerY)
            make.right.equalTo(self.btnRefresh.snp.left).offset(-12)
        }
        self.rotateImg = imgRotate
    }
    
    
    private func setupTableView() {
        
        let bottomView = UIView()
        bottomView.layer.cornerRadius = 12
        bottomView.backgroundColor =  UIColor(named: "bgYellow")
        addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(414)
        }
        self.bottomView = bottomView
        
        let tbView = UITableView(frame: .zero, style: .plain)
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.layer.cornerRadius = 12
        tbView.backgroundColor = UIColor(named: "bgYellow")
        tbView.register(PrayerHederCell.self, forCellReuseIdentifier: PrayerHederCell.className)
        tbView.register(PrayerTimeCell.self, forCellReuseIdentifier: PrayerTimeCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.isScrollEnabled = false
        self.bottomView.addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-6)
        }
        self.tableView = tbView
    }
    
    @objc func btnLeftClicked(){
        self.leftBtnOnClick!(selectedDate)
    }
    @objc func btnRightClicked(){
        self.rightBtnOnClick!(selectedDate)
    }
}

extension PrayerInnerView:UITableViewDataSource, UITableViewDelegate{

    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrayerTimeModel().prayerList.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PrayerHederCell.className
            ) as? PrayerHederCell else { return UITableViewCell() }
            cell.btnLeft.addTarget(self, action: #selector(btnLeftClicked), for: .touchUpInside)
            cell.btnRight.addTarget(self, action: #selector(btnRightClicked), for: .touchUpInside)
            
           // let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "uz_UZ") as Locale
            dateFormatter.dateFormat = "EEEE, d MMM"
            cell.milDate.text = dateFormatter.string(from: selectedDate).capitalized
            
            let hijDays = MainBean.shared.hijDay.split(separator: ",")
            if hijDays.count == 2 {
                cell.hijDate.text = Configs().convertToLatin(name: String(hijDays[0])) + ", " + String(hijDays[1])
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PrayerTimeCell.className
            ) as? PrayerTimeCell else { return UITableViewCell() }
            let item = PrayerTimeModel().prayerList[indexPath.row-1]
            cell.lblName.text = item.name
            let state:String = userDefaults.object(forKey: "sound\(indexPath.row-1)") as? String ?? ""
            if state != ""{
                switch state{
                case "0":
                    cell.btnVoice.setImage(UIImage(named:PrayerTimeModel().prayerSoundsList[0].image)?.withRenderingMode(.alwaysTemplate), for: .normal)
                case "1":
                    cell.btnVoice.setImage(UIImage(named: PrayerTimeModel().prayerSoundsList[1].image)?.withRenderingMode(.alwaysTemplate), for: .normal)
                case "2":
                    cell.btnVoice.setImage(UIImage(named: PrayerTimeModel().prayerSoundsList[2].image)?.withRenderingMode(.alwaysTemplate), for: .normal)
                default:
                    cell.btnVoice.setImage(UIImage(named: PrayerTimeModel().prayerSoundsList[0].image)?.withRenderingMode(.alwaysTemplate), for: .normal)
                }
            } else {
                cell.btnVoice.setImage(UIImage(named: PrayerTimeModel().prayerSoundsList[0].image)?.withRenderingMode(.alwaysTemplate), for: .normal)
            }
            cell.lblTime.text = dateList[indexPath.row-1]
            if indexPath.row-1 == selectedIndex {
                cell.viewBG.backgroundColor = UIColor(named: "bgMain")
                cell.lblName.textColor = .white
                cell.lblTime.textColor = .white
                cell.btnVoice.tintColor = .white
            } else {
                cell.viewBG.backgroundColor = .clear
                cell.lblName.textColor = .black
                cell.lblTime.textColor = .black
                cell.btnVoice.tintColor = UIColor(named: "bgMain")
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            self.prayerTimeOnClick!(indexPath.row, PrayerTimeModel().prayerList[indexPath.row-1].state)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 72
        } else {
            return 56
        }
    }
}

