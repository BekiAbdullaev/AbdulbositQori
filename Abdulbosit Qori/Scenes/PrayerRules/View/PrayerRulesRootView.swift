//
//  PrayerRulesRootView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit

class PrayerRulesRootView: NiblessView {
    
    // MARK: - Outlets
    weak var tableView:UITableView!
    private var selectedIndex = -1
    
    internal var itemOnClick:((Int)->())?
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        setupTableView()
    }
    
    private func setupTableView() {
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.tableHeaderView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(PrayerRulesCell.self, forCellReuseIdentifier: PrayerRulesCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.separatorColor = UIColor.white.withAlphaComponent(0.3)
        tbView.rowHeight = 64
        addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.tableView = tbView
    }
}

extension PrayerRulesRootView:UITableViewDataSource, UITableViewDelegate{
   
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PrayerRuleModel().arrayPrayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrayerRulesCell.className
        ) as? PrayerRulesCell else { return UITableViewCell() }
        cell.lblTittle.text = PrayerRuleModel().arrayPrayer[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemOnClick!(indexPath.row)
    }
}
