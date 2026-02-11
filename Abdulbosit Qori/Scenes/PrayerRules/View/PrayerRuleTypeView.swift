//
//  PrayerRulePagerView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/4/23.
//

import Foundation
import UIKit

class PrayerRuleTypeView: NiblessView {
        
    // MARK: - Outlets
    weak var tableView:UITableView!
    internal var itemOnClick:((Int, Int, String)->Void)?
    var isManRule = false
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(named: "bgMain")
        self.setTableView()
    }
    
    private func setTableView(){
        let tbView = UITableView()
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView()
        tbView.backgroundColor = .clear
        tbView.register(PrayerTypeCell.self, forCellReuseIdentifier: PrayerTypeCell.className)
        tbView.showsVerticalScrollIndicator = false
        tbView.separatorColor = UIColor.white.withAlphaComponent(0.3)
        tbView.rowHeight = 110
        addSubview(tbView)
        tbView.snp.makeConstraints({$0.edges.equalToSuperview()})
        self.tableView = tbView
    }
}

extension PrayerRuleTypeView:UITableViewDataSource, UITableViewDelegate{
   
    // MARK: Table View
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isManRule ? PrayerRuleModel().prayerMenTypes.count : PrayerRuleModel().prayerWomenTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrayerTypeCell.className
        ) as? PrayerTypeCell else { return UITableViewCell() }
        let title = isManRule ?  PrayerRuleModel().prayerMenTypes[indexPath.row] : PrayerRuleModel().prayerWomenTypes[indexPath.row]
        cell.lblTittle.text = title
        cell.prayerTypeIndex = indexPath.row
        cell.itemOnClick = { section, row, title in
            self.itemOnClick!(section, row, title)
        }
        return cell
    }
}
