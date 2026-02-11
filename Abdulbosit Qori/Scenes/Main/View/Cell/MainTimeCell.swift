//
//  MainTimeCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/16/23.
//

import Foundation
import UIKit
import MyLibrary

class MainTimeCell: UITableViewCell {
    
    // MARK: - Views
    weak var prayerTimeView:UIView!
    weak var prayerType:Label!
    weak var prayerTime:Label!
    weak var prayerLeftTime:Label!
    var timer = Timer()
    var secondsLeft = 1
    var hoursLeft = 0
    var minutesLeft = 0
    var spb: SegmentedProgressBar!
    
    
    //MARK: - Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = false
        backgroundColor = .clear
        selectionStyle = .none
        setPrayerTime()
       
    }
    
    func setPrayerTime() {
        let prayerTimeV = UIView()
        prayerTimeV.layer.cornerRadius = 12
        prayerTimeV.backgroundColor = UIColor(named: "bgYellow")
        self.addSubview(prayerTimeV)
        prayerTimeV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(6)
            make.width.equalTo(UIScreen.main.bounds.width-32)
            make.centerX.equalToSuperview()
            make.height.equalTo(138)
        }
        self.prayerTimeView = prayerTimeV
        
        let prayerT = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .black.withAlphaComponent(0.8), text: "-----")
        self.prayerTimeView.addSubview(prayerT)
        prayerT.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
        }
        self.prayerType = prayerT
        
        let prayerTime = Label(font: UIFont.systemFont(ofSize: 32, weight: .bold), lines: 1, color: .black, text: "00:00")
        self.prayerTimeView.addSubview(prayerTime)
        prayerTime.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.top.equalTo(self.prayerType.snp.bottom)
        }
        self.prayerTime = prayerTime
        
        let prayerLeftTime = Label(font: UIFont.systemFont(ofSize: 24, weight: .semibold), lines: 1, color: .black, text: "")
        prayerLeftTime.textAlignment = .right
        self.prayerTimeView.addSubview(prayerLeftTime)
        prayerLeftTime.snp.makeConstraints { make in
            make.centerY.equalTo(self.prayerTime.snp.centerY)
            make.right.equalToSuperview().offset(-12)
        }
        self.prayerLeftTime = prayerLeftTime
        
        let lineView = UIView()
        lineView.backgroundColor = .black.withAlphaComponent(0.1)
        self.prayerTimeView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo( self.prayerTime.snp.bottom).offset(12)
        }
        
        let s = SegmentedProgressBar(numberOfSegments: 20, duration: 60)
        s.frame = CGRect(x: self.prayerTimeView.frame.origin.x + 20, y: self.prayerTimeView.frame.origin.y + 90, width: self.contentView.frame.width - 10, height: 32)
        s.delegate = self
        s.topColor = UIColor(named: "bgMain")!
        s.bottomColor = UIColor(named: "bgMain")!.withAlphaComponent(0.25)
        s.padding = 4
        self.prayerTimeView.addSubview(s)
        self.spb = s
    }
}

extension MainTimeCell:SegmentedProgressBarDelegate{
    func segmentedProgressBarFinished() {}
    func segmentedProgressBarChangedIndex(index: Int) {}
}

extension MainTimeCell {
    func setItems() {
    
        let bomdod = MainBean.shared.bomdodTime
        let quyosh = MainBean.shared.quyoshTime
        let peshin = MainBean.shared.peshinTime
        let asr = MainBean.shared.asrTime
        let shom =  MainBean.shared.shomTime
        let xufton = MainBean.shared.xuftonTime
        let nextDayBomdod = MainBean.shared.nextDayBomdodTime
        let currentTime = getCurrentTime()
            
        
        if checkIfCurrentTimeIsBetween(startTime: bomdod, endTime: quyosh) {
            self.prayerType.text = "Quyosh"
            self.prayerTime.text = quyosh
            timeDifference(start: currentTime, end: quyosh)
        } else if checkIfCurrentTimeIsBetween(startTime: quyosh, endTime: peshin) {
            self.prayerType.text = "Peshin"
            self.prayerTime.text = peshin
            timeDifference(start: currentTime, end: peshin)
        } else if checkIfCurrentTimeIsBetween(startTime: peshin, endTime: asr) {
            self.prayerType.text = "Asr"
            self.prayerTime.text = asr
            timeDifference(start: currentTime, end: asr)
        } else if checkIfCurrentTimeIsBetween(startTime: asr, endTime: shom) {
            self.prayerType.text = "Shom"
            self.prayerTime.text = shom
            timeDifference(start: currentTime, end: shom)
        } else if checkIfCurrentTimeIsBetween(startTime: shom, endTime: xufton) {
            self.prayerType.text = "Xufton"
            self.prayerTime.text = xufton
            timeDifference(start: currentTime, end: xufton)
        }  else if checkIfCurrentTimeIsBetween(startTime:xufton, endTime: "23:59") || checkIfCurrentTimeIsBetween(startTime: "00:00", endTime: nextDayBomdod) {
            self.prayerType.text = "Bomdod"
            if checkIfCurrentTimeIsBetween(startTime:xufton, endTime: "23:59") {
                self.prayerTime.text = nextDayBomdod
                timeDifference(start: currentTime, end: nextDayBomdod, needNextDay: true)
            } else {
                self.prayerTime.text = bomdod
                timeDifference(start: currentTime, end: bomdod, needNextDay: false)
            }
        }
    }
    
    func timeDifference(start:String, end:String, needNextDay:Bool = false){
        var hours = Double()
        var minutes = Double()
        if needNextDay {
            guard let start1 = Formatter.today.date(from: start), let end1 = Formatter.today.date(from: "23:59") else {
                return
            }
            guard let start2 = Formatter.today.date(from: "00:01"), let end2 = Formatter.today.date(from: end) else {
                return
            }
            let elapsedTime1 = end1.timeIntervalSince(start1)
            let elapsedTime2 = end2.timeIntervalSince(start2)
            let totalElapsedTime = elapsedTime1 + elapsedTime2
            hours = floor(totalElapsedTime / 60 / 60)
            minutes = floor((totalElapsedTime - (hours * 60 * 60)) / 60)
        } else {
            guard let start = Formatter.today.date(from: start), let end = Formatter.today.date(from: end) else {
                return
            }
            let elapsedTime = end.timeIntervalSince(start)
            hours = floor(elapsedTime / 60 / 60)
            minutes = floor((elapsedTime - (hours * 60 * 60)) / 60)
        }
       
        self.hoursLeft = Int(hours)
        self.minutesLeft = Int(minutes)
        
        timer = Timer.scheduledTimer(timeInterval: 1.00, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
    }
    
    @objc func onTimerFires(){
        secondsLeft -= 1
        self.prayerLeftTime.text = String(format: "-%02d:%02d:%02d", hoursLeft, minutesLeft, secondsLeft)
        if secondsLeft <= 0 {
            if minutesLeft != 0{
                secondsLeft = 59
                minutesLeft -= 1
            }
        }
        if minutesLeft <= 0 {
            if hoursLeft != 0{
                minutesLeft = 59
                hoursLeft -= 1
            }
        }
        if(hoursLeft == 0 && minutesLeft == 0 && secondsLeft == 0){
            timer.invalidate()
        }
    }
    
    func checkIfCurrentTimeIsBetween(startTime: String, endTime: String) -> Bool {
        guard let start = Formatter.today.date(from: startTime),
              let end = Formatter.today.date(from: endTime) else {
            return false
        }
        return DateInterval(start: start, end: end).contains(Date())
    }
    func getCurrentTime()->String{
        let d = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "uz_Latn_UZ")
        dateFormatter.defaultDate = Calendar.current.startOfDay(for: Date())
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.string(from: d)
        return time
    }
}


public extension Formatter {
    static let today: DateFormatter = {
        let d = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .init(identifier: "uz_Latn_UZ")
        dateFormatter.defaultDate = Calendar.current.startOfDay(for: Date())
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
        
    }()
}
