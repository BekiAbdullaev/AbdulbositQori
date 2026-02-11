//
//  MainBodyCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/17/23.
//

import Foundation
import UIKit
import MyLibrary

protocol MainBodyIxResponder:AnyObject {
    func mainItemsDidSelect(type:MainPageItemType)
}

class MainBodyCell: UITableViewCell {
    
    // MARK: - Views
    weak var footerView:UIView!
    weak var lblTitle:Label!
    weak var imgLogo:UIImageView!
    weak var btnMore:UIButton!
    weak var collectionView: UICollectionView!
    
    // MARK: - Attributes
    weak var ixResponder:MainBodyIxResponder?
    
    //MARK: - Methods
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = false
        backgroundColor = .clear
        selectionStyle = .none
        self.setUpCollectionView()
    }
    func setUpCollectionView() {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: CollectionViewFlowLayout.init(display: .mainItem))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(MainItemCell.self, forCellWithReuseIdentifier: MainItemCell.className)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        self.contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(3)
        }
        self.collectionView = collectionView
    }
}

extension MainBodyCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MainPageModel().listMainItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCell.className, for: indexPath) as? MainItemCell else { return UICollectionViewCell() }
        let item = MainPageModel().listMainItems[indexPath.row]
        cell.itemName.text = item.title
        cell.itemIcon.image = UIImage(named: item.image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.ixResponder?.mainItemsDidSelect(type: MainPageModel().listMainItems[indexPath.row].type)
    }
}
