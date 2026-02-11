//
//  QiblaRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit

class QiblaRootView: NiblessView {
    
    weak var prayerType:Label!
    weak var prayerTime:Label!
    weak var leftTime:Label!
    weak var userLocation:Label!
    weak var compusImage:UIImageView!
    
   
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        self.setItems()
    }
    
    func setItems(){
        let lblType = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .white)
        lblType.textAlignment = .center
        self.addSubview(lblType)
        lblType.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(UIScreen.main.bounds.height*0.05)
        }
        self.prayerType = lblType
        
        let lblTime = Label(font: UIFont.systemFont(ofSize: 48, weight: .bold), lines: 1, color: .white)
        lblTime.textAlignment = .center
        self.addSubview(lblTime)
        lblTime.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.prayerType.snp.bottom)
        }
        self.prayerTime = lblTime
        
        let lblLeft = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .white)
        lblLeft.textAlignment = .center
        self.addSubview(lblLeft)
        lblLeft.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.prayerTime.snp.bottom)
        }
        self.leftTime = lblLeft
        
        let location = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 2, color: .white.withAlphaComponent(0.8), text: "Toshkent (shim.keng: 41.33 / sharq.uzun: 69.32)")
        location.textAlignment = .center
        self.addSubview(location)
        location.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-UIScreen.main.bounds.height*0.05)
        }
        self.userLocation = location
        
        let footerTitle = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 1, color: .white, text: "Siz turgan mintaqa")
        footerTitle.textAlignment = .center
        self.addSubview(footerTitle)
        footerTitle.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.userLocation.snp.top).offset(-8)
        }
        
        let compus = UIImageView()
        compus.image = UIImage(named: "ic_qibla")
        compus.contentMode = .scaleAspectFill
        self.addSubview(compus)
        compus.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(compus.snp.width)
        }
        self.compusImage = compus
    }
}
