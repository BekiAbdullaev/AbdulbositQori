//
//  CompusUseageVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import UIKit
import PanModal

class CompusUseageVC: UIViewController,PanModalPresentable {
    weak var itemImage:UIImageView!
    weak var itemTitle:Label!
    weak var btnOK:UIButton!
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgYellow")
        
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "ic_infinity")
        self.view.addSubview(img)
        img.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(img.snp.width).multipliedBy(0.7)
            make.top.equalToSuperview().offset(24)
        }
        self.itemImage = img
        
        let btn = UIButton()
        btn.setTitle("Tushunarli", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(understandClick), for: .touchUpInside)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = UIColor(named: "bgMain")
        self.view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-24)
            make.height.equalTo(49)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        self.btnOK = btn
        
        let lbl = Label(font: UIFont.systemFont(ofSize: 18, weight: .regular), lines: 0, color: .black)
        lbl.attributedText = String.setLineSpace(text: "Qiblani ko’rsatuvchi kompas aniq ishlashi uchun, mobile telefoningizni 8 (sakkiz) raqami shaklida aylantirib olshingiz kerak.", space: 5)
        lbl.textAlignment = .center
        self.view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalTo(self.itemImage.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(self.btnOK.snp.top).offset(-20)
        }
        self.itemTitle = lbl
        
       
    }
    
    var longFormHeight: PanModalHeight {
        return .contentHeight(CGFloat(UIScreen.main.bounds.height * 0.4))
    }
    
    var panScrollable: UIScrollView? {
        return nil
    }
    
    @objc func understandClick() {
        self.dismiss(animated: true)
    }
}

