//
//  PrayerHederCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/18/23.
//

import Foundation
import UIKit
import MyLibrary

class PrayerHederCell: UITableViewCell {
    
    // MARK: - Views
    weak var btnLeft:UIButton!
    weak var btnRight:UIButton!
    weak var milDate:Label!
    weak var hijDate:Label!
    
    
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
        let btnLeft = UIButton()
        btnLeft.setImage(UIImage(named: "ic_left"), for: .normal)
        contentView.addSubview(btnLeft)
        btnLeft.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.btnLeft = btnLeft
        
        let lblMil = Label(font: UIFont.systemFont(ofSize: 16, weight: .semibold), lines: 1, color: .black)
        lblMil.textAlignment = .center
        contentView.addSubview(lblMil)
        lblMil.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        self.milDate = lblMil
        
        let lblHij = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .black.withAlphaComponent(0.8))
        lblHij.textAlignment = .center
        contentView.addSubview(lblHij)
        lblHij.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(10)
        }
        self.hijDate = lblHij
    
        let btnRight = UIButton()
        btnRight.setImage(UIImage(named: "ic_right"), for: .normal)
        contentView.addSubview(btnRight)
        btnRight.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.height.equalTo(40)
            make.width.equalTo(24)
        }
        self.btnRight = btnRight
        
    }
    
}
