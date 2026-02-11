//
//  MainAboutCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/17/23.
//

import Foundation
import UIKit
import MyLibrary

class MainAboutCell: UITableViewCell {
    
    // MARK: - Views
    weak var footerView:UIView!
    weak var lblTitle:Label!
    weak var imgLogo:UIImageView!
    weak var btnMore:UIButton!
    internal var aboutOnClick:(()->Void)?
    
    
    //MARK: - Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = false
        backgroundColor = .clear
        selectionStyle = .none
        
        let footerV = UIView()
        footerV.layer.cornerRadius = 12
        footerV.backgroundColor = UIColor(named: "bgYellow")
        self.contentView.addSubview(footerV)
        footerV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(131)
        }
        self.footerView = footerV
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "img_profile")
        self.footerView.addSubview(img)
        img.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(113)
            make.left.equalToSuperview().offset(8)
        }
        self.imgLogo = img
        
        let lbl = Label(font: UIFont.systemFont(ofSize: 20, weight: .semibold), lines: 2, color: .black, text: "Abdulbosit qori\nhaqida")
        self.footerView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.left.equalTo(self.imgLogo.snp.right).offset(16)
            make.top.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-16)
        }
        self.lblTitle = lbl
        
        let btn = UIButton()
        btn.setTitle("Batafsil", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor(named: "bgMain")
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        btn.addTarget(self, action: #selector(aboutClicked), for: .touchUpInside)
        self.footerView.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.equalTo(self.imgLogo.snp.right).offset(16)
            make.top.equalTo(self.lblTitle.snp.bottom).offset(16)
            make.height.equalTo(33)
            make.width.equalTo(110)
        }
        self.btnMore = btn
    }
    
    @objc func aboutClicked() {
        self.aboutOnClick!()
    }
    
}
