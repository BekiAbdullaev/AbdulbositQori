//
//  QuranBribesImgCell.swift
//  Abdulbosit Qori
//
//  Created by Abdullaev Bekzod on 17/09/23.
//

import Foundation
import UIKit

final class QuranBribesImgCell:ClicakbleCollectionViewCell {
    // MARK: - Outlets
  
    weak var itemIcon:UIImageView!

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
        contentView.layer.cornerRadius = 16
        let img = UIImageView()
        img.image = UIImage(named: "ic_logo_audio")
        img.contentMode = .scaleAspectFill
        contentView.addSubview(img)
        img.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(16)
        }
        self.itemIcon = img
    }
    
}
