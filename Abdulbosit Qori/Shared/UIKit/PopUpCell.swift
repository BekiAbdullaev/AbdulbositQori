//
//  PopUpCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/20/23.
//

import Foundation
import UIKit

class PopUpCell: UITableViewCell {
    
    // MARK: - Views
    weak var lblTittle:Label!
    weak var lblFirstSubtitle:Label!
    weak var lblArabicTitle:Label!
    weak var lblSecondTitle:Label!

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

        let title = Label(font: UIFont.systemFont(ofSize: 15, weight: .semibold), lines: 0, color: .black)
        title.textAlignment = .left
        self.contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
        }
        self.lblTittle = title
        
        let fsubtitle = Label(font: UIFont.systemFont(ofSize: 15, weight: .regular), lines: 0, color: .black)
        fsubtitle.textAlignment = .left
        self.contentView.addSubview(fsubtitle)
        fsubtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.lblTittle.snp.bottom).offset(10)
        }
        self.lblFirstSubtitle = fsubtitle
        
        let arabicTitle = Label(font: UIFont.systemFont(ofSize: 15, weight: .regular), lines: 0, color: .black)
        arabicTitle.textAlignment = .right
        self.contentView.addSubview(arabicTitle)
        arabicTitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.lblFirstSubtitle.snp.bottom).offset(10)
        }
        self.lblArabicTitle = arabicTitle
        
        let ssubtitle = Label(font: UIFont.systemFont(ofSize: 15, weight: .regular), lines: 0, color: .black)
        ssubtitle.textAlignment = .left
        self.contentView.addSubview(ssubtitle)
        ssubtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(self.lblArabicTitle.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-12)
        }
        self.lblSecondTitle = ssubtitle
    }
    
    func setElements(item:PrayerRulePopUpModel) {
        self.lblTittle.attributedText = String.setLineSpace(text: item.title,space: 6)
        self.lblFirstSubtitle.attributedText = String.setLineSpace(text: item.firstSubtitle,space: 6)
        self.lblArabicTitle.text = item.arabicSubtitle
        self.lblSecondTitle.attributedText = String.setLineSpace(text: item.secondSubtitle,space: 6)
    }
}
