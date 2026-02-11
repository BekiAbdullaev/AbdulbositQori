//
//  MainRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/2/23.
//

import Foundation
import UIKit
import MyLibrary

class MainRootView: NiblessView {
    
    weak var tableView: UITableView!
    weak var topView:UIView!
    
    internal var cityOnClick:(()->Void)?
    internal var aboutOnClick:(()->Void)?
    weak var ixResponder:MainBodyIxResponder?
    
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        self.setTopLogo()
        self.setupTableView()
    }
    
    func setTopLogo(){
        let topView = UIView()
        topView.layer.cornerRadius = 12
        topView.backgroundColor = UIColor(named: "bgYellow")
        self.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(16)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(58)
        }
        self.topView = topView
        
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.image = UIImage(named: "ic_logo_green")
        topView.addSubview(logo)
        logo.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
            make.height.width.equalTo(58)
        }
    }
    
    private func setupTableView() {
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(MainPlaceCall.self, forCellReuseIdentifier: MainPlaceCall.className)
        tbView.register(MainTimeCell.self, forCellReuseIdentifier: MainTimeCell.className)
        tbView.register(MainAboutCell.self, forCellReuseIdentifier: MainAboutCell.className)
        tbView.register(MainBodyCell.self, forCellReuseIdentifier: MainBodyCell.className)
        tbView.showsVerticalScrollIndicator = false
        addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.top.equalTo(self.topView.snp.bottom).offset(8)
            make.left.bottom.right.equalToSuperview()
        }
        self.tableView = tbView
    }
}

extension MainRootView:UITableViewDataSource, UITableViewDelegate{
   
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainPlaceCall.className
            ) as? MainPlaceCall else { return UITableViewCell() }
            cell.cityOnClick = {
                self.cityOnClick!()
            }
            cell.setItems()
            return cell
        } else if indexPath.row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTimeCell.className
            ) as? MainTimeCell else { return UITableViewCell() }
            cell.setItems()
            cell.spb.startAnimation()
            cell.spb.animateToIndex(index: Configs().getProgressAnimatedIndex())
            return cell
        } else if indexPath.row == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainBodyCell.className
            ) as? MainBodyCell else { return UITableViewCell() }
            cell.ixResponder = ixResponder
            return cell
        } else if indexPath.row == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MainAboutCell.className
            ) as? MainAboutCell else { return UITableViewCell() }
            cell.aboutOnClick = {
                self.aboutOnClick!()
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 120
        case 1:
            return 150
        case 2:
            return CGFloat((UIScreen.main.bounds.width-42)/2)*3+25
        case 3:
            return 156
        default:
            return 0
        }
    }
}
