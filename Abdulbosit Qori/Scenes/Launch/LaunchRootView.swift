//
//  LaunchRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import UIKit
import SnapKit

class LaunchRootView: UIView {
    
    weak var imageLogo:UIImageView!
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpUI() {
        self.backgroundColor = UIColor(named: "bgMain")
        self.setLogo()
    }
    
    func setLogo() {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "ic_logo_yellow")
        self.addSubview(img)
        img.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(250)
        }
        self.imageLogo = img
    }
}
