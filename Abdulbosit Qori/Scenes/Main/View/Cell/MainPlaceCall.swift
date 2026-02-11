//
//  MainPlaceCall.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/16/23.
//

import Foundation
import UIKit
import MyLibrary

class MainPlaceCall: UITableViewCell {
    
    // MARK: - Views
    weak var placeView:UIView!
    weak var lblCity:PaddingLabel!
    weak var milDate:Label!
    weak var hijDate:Label!
    
    internal var cityOnClick:(()->Void)?
    
    //MARK: - Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = false
        backgroundColor = .clear
        selectionStyle = .none
        setPlaceView()
    }
    
    func setItems(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "uz_UZ") as Locale
        dateFormatter.dateFormat = "EEEE, d MMM"
        let milDays = dateFormatter.string(from: date).split(separator: ",")
        if milDays.count == 2 {
            self.milDate.attributedText = String.generateFracktionAttributedString(title: "\(milDays[0].capitalized),", fracTittle: String(milDays[1]))
        }
        let hijDays = MainBean.shared.hijDay.split(separator: ",")
        if hijDays.count == 2 {
            self.hijDate.attributedText = String.generateFracktionAttributedString(title: "\(Configs().convertToLatin(name: String(hijDays[0])))", fracTittle: String(hijDays[1]))
        }
        self.lblCity.text = MainBean.shared.selectedCity
    }
    func setPlaceView() {
        let placeV = UIView()
        placeV.layer.cornerRadius = 12
        placeV.backgroundColor = UIColor(named: "bgYellow")
        self.contentView.addSubview(placeV)
        placeV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(114)
        }
        self.placeView = placeV
                
        let city = PaddingLabel(withInsets: 10, 10, 18, 38)
        city.font = .systemFont(ofSize: 16, weight: .regular)
        city.textColor = .white
        city.layer.cornerRadius = 19
        city.clipsToBounds = true
        city.textAlignment = .center
        city.backgroundColor = UIColor(named: "bgMain")
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        city.isUserInteractionEnabled = true
        city.addGestureRecognizer(tap)
        self.placeView.addSubview(city)
        city.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(12)
        }
        self.lblCity = city
        
        let icDrop = UIImageView()
        icDrop.contentMode = .scaleAspectFit
        icDrop.image = UIImage(named: "ic_drop")
        lblCity.addSubview(icDrop)
        icDrop.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.height.width.equalTo(16)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .black.withAlphaComponent(0.1)
        self.placeView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.right.equalToSuperview().inset(12)
            make.top.equalTo(lblCity.snp.bottom).offset(12)
        }
        
        let milD = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .black)
        let hijD = Label(font: UIFont.systemFont(ofSize: 16, weight: .regular), lines: 1, color: .black)
        hijD.textAlignment = .right
        self.milDate = milD
        self.hijDate = hijD
        let stackDate = StackView(axis: .horizontal, alignment: .center, distribution: .fillEqually, spacing: 20, views: [milD, hijD])
        self.placeView.addSubview(stackDate)
        stackDate.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(12)
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.cityOnClick!()
    }
}
