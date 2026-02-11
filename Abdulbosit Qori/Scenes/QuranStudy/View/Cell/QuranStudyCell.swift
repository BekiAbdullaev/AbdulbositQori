//
//  QuranStudyCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit

class QuranStudyCell: UITableViewCell {
    
    // MARK: - Views
    weak var viewBG:UIView!
    weak var playBtn:UIButton!
    weak var lblTittle:Label!
    weak var lblTime:Label!
   
        
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
        
        let time = Label(font: UIFont.systemFont(ofSize: 14, weight: .regular), lines: 1, color: .white.withAlphaComponent(0.8))
        time.textAlignment = .right
        self.viewBG.addSubview(time)
        time.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        self.lblTime = time
        
        let title = Label(font: UIFont.systemFont(ofSize: 16, weight: .medium), lines: 1, color: .white, text: "Fotaha")
        self.viewBG.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalTo(self.playBtn.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(self.lblTime.snp.left).offset(-16)
        }
        self.lblTittle = title
    }
}
