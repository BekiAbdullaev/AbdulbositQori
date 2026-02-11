//
//  PrayerRakatCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/6/23.
//

import UIKit

class PrayerRakatCell:UICollectionViewCell {
    
    weak var viewBG:UIView!
    weak var title:Label!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initUI() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        let view = UIView()
        view.backgroundColor = UIColor(named: "bgYellow")
        view.layer.cornerRadius = 20
        self.contentView.addSubview(view)
        view.snp.makeConstraints({$0.edges.equalToSuperview()})
        self.viewBG = view
        
        let title = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .black)
        self.contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(14)
        }
        self.title = title
        
    }
}
