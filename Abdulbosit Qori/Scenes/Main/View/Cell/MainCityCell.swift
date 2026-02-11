//
//  MainCityCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/8/23.
//

import Foundation
import UIKit

class MainCityCell: UITableViewCell {
    
    // MARK: - Views
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
        let city = Label(font: UIFont.systemFont(ofSize: 16, weight: .semibold), lines: 1, color: .white)
        self.contentView.addSubview(city)
        city.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        self.lblName = city
    }
}
