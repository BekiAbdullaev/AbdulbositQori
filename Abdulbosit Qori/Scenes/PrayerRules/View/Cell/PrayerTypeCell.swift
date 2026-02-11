//
//  PrayerTypeCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 4/6/23.
//

import Foundation
import UIKit

class PrayerTypeCell: UITableViewCell {
    
    internal var itemOnClick:((Int, Int, String)->Void)?
    // MARK: - Views
    var prayerTypeIndex = -1
    weak var lblTittle:Label!
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.setCollectionViewLayout(layout, animated: false)
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        view.delegate = self
        view.dataSource = self
        view.contentInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        view.register(PrayerRakatCell.self,
                      forCellWithReuseIdentifier: PrayerRakatCell.className)
        return view
    }()
    
   
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
        let title = Label(font: UIFont.systemFont(ofSize: 18, weight: .medium), lines: 1, color: .white)
        self.contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(20)
        }
        self.lblTittle = title
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.lblTittle.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
    }
}

extension PrayerTypeCell:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PrayerRuleModel().prayerRakats[prayerTypeIndex].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PrayerRakatCell.className, for: indexPath) as? PrayerRakatCell else {return UICollectionViewCell()}
        let item = PrayerRuleModel().prayerRakats[prayerTypeIndex][indexPath.row]
        cell.title.text = item
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = PrayerRuleModel().prayerRakats[prayerTypeIndex][indexPath.row]
        let width = self.estimatedFrame(text: item, font: UIFont.systemFont(ofSize: 14)).width
        return CGSize(width: width+28, height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = PrayerRuleModel().prayerRakats[prayerTypeIndex][indexPath.row]
        self.itemOnClick!(self.prayerTypeIndex, indexPath.row, item)
    }
    
    func estimatedFrame(text: String, font: UIFont) -> CGRect {
        let size = CGSize(width: 100, height: 40) // temporary size
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size,
                                                   options: options,
                                                   attributes: [NSAttributedString.Key.font: font],
                                                   context: nil)
    }
}
