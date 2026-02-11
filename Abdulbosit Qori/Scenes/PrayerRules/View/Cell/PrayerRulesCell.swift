//
//  PrayerRulesCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit

class PrayerRulesCell: UITableViewCell {
    
    // MARK: - Views
    weak var viewBG:UIView!
    weak var lblTittle:Label!
    weak var rowIcon:UIImageView!
   
        
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
            make.top.bottom.equalToSuperview().inset(10)
        }
        self.viewBG = viewbg
        
        
        let title = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 1, color: .white)
        self.viewBG.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        self.lblTittle = title
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "ic_right")?.withRenderingMode(.alwaysTemplate)
        img.tintColor = .white
        self.viewBG.addSubview(img)
        img.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-8)
            make.height.width.equalTo(16)
        }
        self.rowIcon = img
    }
}
