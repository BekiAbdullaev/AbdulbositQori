//
//  PopUpView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/8/23.
//

import Foundation
import UIKit

class PopUpView:UIView{
    
    weak var scrollView:UIScrollView!
    weak var contentView:UIView!
    var itemsList = [PrayerRulePopUpModel](){
        didSet{
            tableView.reloadData()
        }
    }
    var title:String = ""{
        didSet {
            lblTitle.text = title
        }
    }
    
    var subtitle:String = "" {
        didSet {
            let allText = subtitle
            if allText == "sanoFotihaKavsar" || allText == "fotihaIxlos" || allText == "tashahudSalovotDuo" || allText == "sanoFotihaFalaq" || allText == "fotihaNas" || allText == "tashahud" || allText == "fotihaFalaq" || allText == "fotiha" || allText == "fotihaKavsar" || allText == "sanoFotihaAsr" || allText == "fotihaNasr"{
                self.contentView.isHidden = true
                self.tableView.isHidden = false
                container.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-65)
                    make.left.right.equalToSuperview().inset(16)
                    make.height.equalTo(UIScreen.main.bounds.size.height*0.8)
                }
                
                switch allText {
                case "sanoFotihaKavsar":
                    itemsList = PrayerRuleModel().sanoFotihaKavsar
                case "fotihaIxlos":
                    itemsList = PrayerRuleModel().fotihaIxlos
                case "tashahudSalovotDuo":
                    itemsList = PrayerRuleModel().tashahudSalovotDuo
                case "sanoFotihaFalaq":
                    itemsList = PrayerRuleModel().sanoFotihaFalaq
                case "fotihaNas":
                    itemsList = PrayerRuleModel().fotihaNas
                case "tashahud":
                    itemsList = PrayerRuleModel().tashahud
                case "fotihaFalaq":
                    itemsList = PrayerRuleModel().fotihaFalaq
                case "fotiha":
                    itemsList = PrayerRuleModel().fotiha
                case "fotihaKavsar":
                    itemsList = PrayerRuleModel().fotihaKavsar
                case "sanoFotihaAsr":
                    itemsList = PrayerRuleModel().sanoFotihaAsr
                case "fotihaNasr":
                    itemsList = PrayerRuleModel().fotihaNasr
                default:
                    itemsList = []
                }
            } else {
                var attributedString = NSMutableAttributedString()
                attributedString = NSMutableAttributedString(string: allText, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)])
                for item in PrayerRuleModel().attrDetilsWords {
                    let range = (allText as NSString).range(of: item)
                    attributedString.setAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black], range: range)
                }
                lblSubtitle.attributedText = String.setLineSpaceAttributed(attributedString: attributedString, space: 6)
                let height = getLabelHeight(str: subtitle) > UIScreen.main.bounds.size.height*0.8 ? UIScreen.main.bounds.size.height*0.8 : getLabelHeight(str: subtitle)
                container.snp.remakeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.centerY.equalToSuperview().offset(-65)
                    make.left.right.equalToSuperview().inset(16)
                    make.height.equalTo(height)
                }
            }
        }
    }
    
    fileprivate let container:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(named: "bgLightYellow")
        v.layer.cornerRadius = 20
        return v
    }()
    
    fileprivate let lblTitle:Label = {
        let lbl = Label(font: .systemFont(ofSize: 20, weight: .semibold), lines: 1, color: .black)
        return lbl
    }()
    
    fileprivate let lblSubtitle:Label = {
        let lbl = Label(font: .systemFont(ofSize: 15, weight: .regular), lines: 0, color: .black)
        return lbl
    }()
    
    fileprivate lazy var tableView:UITableView = {
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.isHidden = true
        tbView.tableFooterView = UIView()
        tbView.tableHeaderView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(PopUpCell.self, forCellReuseIdentifier: PopUpCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.separatorColor = UIColor.white.withAlphaComponent(0.3)
        return tbView
    }()
        
    fileprivate let btnClose:UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Yopish", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        btn.backgroundColor = UIColor(named: "bgMain")
        btn.layer.cornerRadius = 21
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.addGestureRecognizer(tap)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabelHeight(str:String)->CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.size.width-64, height: .greatestFiniteMagnitude)
        let boundingBox = str.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)], context: nil)
        return boundingBox.height + 171
    }
    
    func setUI(){
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        self.addSubview(container)
        container.addSubview(btnClose)
        container.addSubview(lblTitle)
        self.setupScrollView()
        self.contentView.addSubview(lblSubtitle)
        container.addSubview(tableView)
        btnClose.addTarget(self, action: #selector(cloaseAlert), for: .touchUpInside)
        
    
        container.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(UIScreen.main.bounds.height/2)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }
        btnClose.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.left.right.bottom.equalToSuperview().inset(16)
            make.height.equalTo(42)
        }
        lblTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.left.right.equalToSuperview().inset(16)
        }
        lblSubtitle.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().offset(-16)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lblTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(btnClose.snp.top).offset(-12)
        }
        self.animateIn()
    }
    
    func setupScrollView() {
        let scrollView = UIScrollView()
        scrollView.layer.cornerRadius = 12
        scrollView.backgroundColor = UIColor(named: "bgLightYellow")
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isUserInteractionEnabled = true
        container.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(56)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.bottom.equalTo(btnClose.snp.top).offset(-16)
            make.width.equalTo(container)
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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.animateOut()
    }
    
    @objc func cloaseAlert() {
        self.animateOut()
    }
    
    fileprivate func animateOut() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) {(complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 0
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
}

extension PopUpView:UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PopUpCell.className, for: indexPath) as? PopUpCell else {return UITableViewCell()}
        let item = self.itemsList[indexPath.row]
        cell.setElements(item: item)
        return cell
    }
    
}
