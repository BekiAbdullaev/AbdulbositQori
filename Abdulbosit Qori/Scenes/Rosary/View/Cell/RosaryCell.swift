//
//  RosaryCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/6/23.
//

import Foundation
import UIKit

class RosaryCell: UITableViewCell {
    
    // MARK: - Views
    weak var viewBG:UIView!
    weak var playBtn:UIButton!
    weak var lblTittle:Label!
    weak var indicator:UIActivityIndicatorView!
    weak var lblCount:Label!
   
        
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
            make.left.right.top.bottom.equalToSuperview().inset(6)
        }
        self.viewBG = viewbg
        
        let btnPlay = UIButton()
        btnPlay.setImage(UIImage(named: "ic_play_yellow"), for: .normal)
        btnPlay.imageView?.contentMode = .scaleAspectFit
        self.viewBG.addSubview(btnPlay)
        btnPlay.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.height.equalTo(40)
            make.width.equalTo(28)
        }
        self.playBtn = btnPlay
        
        let count = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white.withAlphaComponent(0.8))
        count.textAlignment = .right
        self.viewBG.addSubview(count)
        count.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        self.lblCount = count
        
        let indicator = UIActivityIndicatorView(style: .white)
        self.viewBG.addSubview(indicator)
        self.viewBG.bringSubviewToFront(indicator)
        indicator.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-35)
            make.height.equalTo(40)
            make.width.equalTo(40)
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.indicator = indicator
        
        let title = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 2, color: .white, text: "Fotaha")
        self.viewBG.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(self.playBtn.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.lblCount.snp.left).offset(-40)
        }
        self.lblTittle = title
    }
}
