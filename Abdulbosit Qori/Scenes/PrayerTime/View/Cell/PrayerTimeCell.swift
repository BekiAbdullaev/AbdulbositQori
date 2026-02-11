//
//  PrayerTimeCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/5/23.
//

import Foundation
import UIKit

class PrayerTimeCell: UITableViewCell {
    
    // MARK: - Views
    weak var viewBG:UIView!
    weak var btnVoice:UIButton!
    weak var lblName:Label!
    weak var lblLeftTime:Label!
    weak var lblTime:Label!
   
        
    //MARK: - Methods
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
    
    func setItems(){
        let viewbg = UIView()
        viewbg.backgroundColor = .clear
        viewbg.layer.cornerRadius = 7
        self.contentView.addSubview(viewbg)
        viewbg.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview()
        }
        self.viewBG = viewbg
        
        let btnVoi = UIButton()
        btnVoi.setImage(UIImage(named: "ic_mute")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnVoi.tintColor = UIColor(named: "bgMain")
        self.viewBG.addSubview(btnVoi)
        btnVoi.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.btnVoice = btnVoi
        
        let time = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .black, text: "05:34")
        time.textAlignment = .right
        self.viewBG.addSubview(time)
        time.snp.makeConstraints { make in
            make.right.equalTo(self.btnVoice.snp.left).offset(-12)
            make.centerY.equalToSuperview()
        }
        self.lblTime = time
        
        let name = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 1, color: .black, text: "Bomdod")
        self.viewBG.addSubview(name)
        name.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        self.lblName = name
        
        let left = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white, text: "-00:03:32")
        left.isHidden = true
        self.viewBG.addSubview(left)
        left.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        self.lblLeftTime = left
    }
}
