//
//  AboutRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit

final class AboutRootView: UIView {
    // MARK: - Outlets
    weak var scrollView:UIScrollView!
    weak var contentView:UIView!
    weak var lblName:Label!
    weak var bgProfile:UIImageView!
    weak var btnFacebook:UIButton!
    weak var btnInstagram:UIButton!
    weak var btnTelegram:UIButton!
    weak var btnYoutube:UIButton!
    weak var lblShortDetail:Label!
    weak var lblDetail:Label!
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    private func setupUI() {
        clipsToBounds = true
        backgroundColor = UIColor(named: "bgMain")
        
        self.setupScrollView()
        self.setupLabel()
    }
    
    func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.layer.cornerRadius = 12
        scrollView.backgroundColor = UIColor(named: "bgLightYellow")
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.width.equalTo(UIScreen.main.bounds.width-32)
            make.centerX.equalTo(self.snp.centerX)
        }
        self.scrollView = scrollView
        let content = UIView()
        scrollView.addSubview(content)
        content.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0.0)
            make.width.equalTo(UIScreen.main.bounds.width-32)
        }
        scrollView.contentSize = content.frame.size
        self.contentView = content
    }
    
    private func setupLabel() {
        let name = Label(font: UIFont.systemFont(ofSize: 20, weight: .bold), lines: 0, color: .black)
        name.addCharacterSpacing(kernValue: -0.24)
        self.contentView.addSubview(name)
        name.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview().inset(16)
        }
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "img_profile_1")
        self.contentView.addSubview(img)
        img.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(140)
        }
        
        let btnF = UIButton()
        btnF.setImage(UIImage(named: "ic_facebook"), for: .normal)
        self.contentView.addSubview(btnF)
        btnF.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(img.snp.bottom).offset(16)
            make.width.height.equalTo(24)
        }
        self.btnFacebook = btnF
        
        let btnI = UIButton()
        btnI.setImage(UIImage(named: "ic_instagram"), for: .normal)
        self.contentView.addSubview(btnI)
        btnI.snp.makeConstraints { make in
            make.left.equalTo(self.btnFacebook.snp.right).offset(12)
            make.centerY.equalTo(self.btnFacebook.snp.centerY)
            make.width.height.equalTo(24)
        }
        self.btnInstagram = btnI
        
        let btnT = UIButton()
        btnT.setImage(UIImage(named: "ic_telegram"), for: .normal)
        self.contentView.addSubview(btnT)
        btnT.snp.makeConstraints { make in
            make.left.equalTo(self.btnInstagram.snp.right).offset(12)
            make.centerY.equalTo(self.btnFacebook.snp.centerY)
            make.width.height.equalTo(24)
        }
        self.btnTelegram = btnT
        
        let btnY = UIButton()
        btnY.setImage(UIImage(named: "ic_youtube"), for: .normal)
        self.contentView.addSubview(btnY)
        btnY.snp.makeConstraints { make in
            make.left.equalTo(self.btnTelegram.snp.right).offset(12)
            make.centerY.equalTo(self.btnFacebook.snp.centerY)
            make.width.height.equalTo(24)
        }
        self.btnYoutube = btnY
      
        let shortDetail = Label(font:UIFont.systemFont(ofSize: 15, weight: .semibold), lines: 0, color: .black)
        let detail = Label(font: UIFont.italicSystemFont(ofSize: 15), lines: 0, color: .black)
       
        let stack = StackView(axis: .vertical, alignment: .fill, distribution: .fillProportionally, spacing: 16, views: [shortDetail,detail])
        self.contentView.addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.top.equalTo(self.btnFacebook.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        self.lblName = name
        self.lblShortDetail = shortDetail
        self.lblDetail = detail
    }

}
