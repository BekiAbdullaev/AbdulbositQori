//
//  ChooseCitiesVC.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/8/23.
//

import UIKit
import PanModal
import MyLibrary

protocol ChooseCitiesIxResponder:AnyObject {
    func selectedCity(item:Regions)
}

class ChooseCitiesVC:UIViewController,PanModalPresentable {
    weak var delegate: ChooseCitiesIxResponder?
    var regions: [Regions]? {
        didSet {
            guard regions != nil else { return }
            self.tableView.reloadData()
        }
    }
    var panScrollable: UIScrollView? {
        return nil
    }
    var longFormHeight: PanModalHeight {
        let height = min(UIScreen.main.bounds.height * 0.5, 52.0 + CGFloat(regions?.count ?? 0) * 76.0 + getBottomPadding())
        return .contentHeight(height)
    }
    // MARK: Outlets
    private lazy var tittle:UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        lbl.text = "Shaharni tanlang"
        lbl.textAlignment = .left
        lbl.textColor = .white
        return lbl
    }()
    private let tableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.register(MainCityCell.self, forCellReuseIdentifier: MainCityCell.className)
        table.rowHeight = 50
        table.separatorInset = UIEdgeInsets(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0)
        table.backgroundColor = .clear
        table.insetsContentViewsToSafeArea = false
        table.contentInsetAdjustmentBehavior = .never
        return table
    }()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "bgMain")
        self.view.addSubview(tittle)
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        setFrame()
    }
}

extension ChooseCitiesVC {
    private func setFrame() {
        tittle.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(28)
        }
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tittle.snp.bottom).offset(16)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-16)
        }
    }
}

// MARK: - TableView Delegate and Datasource
extension ChooseCitiesVC:UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainCityCell.className, for: indexPath) as? MainCityCell else { return UITableViewCell()}
        cell.lblName.text = regions?[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true) {
            self.delegate?.selectedCity(item: (self.regions?[indexPath.row])!)
        }
    }
}
