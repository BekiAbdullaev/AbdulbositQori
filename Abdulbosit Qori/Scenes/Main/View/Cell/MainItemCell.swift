//
//  MainItemCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/17/23.
//

import Foundation
import UIKit

final class MainItemCell:ClicakbleCollectionViewCell {
    // MARK: - Outlets
    weak var bgView:UIView!
    weak var itemIcon:UIImageView!
    weak var itemName:Label!

    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        clipsToBounds = true
        let viewbg = UIView()
        viewbg.clipsToBounds = true
        viewbg.backgroundColor = UIColor(named: "bgYellow")
        viewbg.layer.cornerRadius = 12
        contentView.addSubview(viewbg)
        viewbg.snp.makeConstraints({$0.edges.equalToSuperview()})
        self.bgView = viewbg
        
        let title = Label(font: UIFont.systemFont(ofSize: 20, weight: .semibold), lines: 2, color: .black)
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(12)
        }
        self.itemName = title
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        contentView.addSubview(img)
        img.snp.makeConstraints { make in
            make.left.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        self.itemIcon = img
    }
}
