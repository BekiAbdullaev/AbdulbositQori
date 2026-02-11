//
//  PrayerTimeControlCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/11/23.
//

import Foundation
import UIKit

class PrayerTimeControlCell: UITableViewCell {
    
    // MARK: - Views
    weak var viewBG:UIView!
    weak var btnVoice:UIButton!
    weak var imgType:UIImageView!
    weak var lblName:Label!
    
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
        btnVoi.imageView?.contentMode = .scaleAspectFit
        self.viewBG.addSubview(btnVoi)
        btnVoi.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.btnVoice = btnVoi
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "ic_mute")?.withRenderingMode(.alwaysTemplate)
        self.viewBG.addSubview(img)
        img.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.height.width.equalTo(24)
        }
        self.imgType = img
        
        let name = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 1, color: .black)
        self.viewBG.addSubview(name)
        name.snp.makeConstraints { make in
            make.left.equalTo(self.imgType.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.btnVoice.snp.left).offset(-16)
        }
        self.lblName = name
    
    }
}
