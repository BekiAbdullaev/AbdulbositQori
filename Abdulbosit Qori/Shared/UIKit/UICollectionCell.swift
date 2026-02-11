//
//  UIClollectionCell.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/3/23.
//

import UIKit
import MyLibrary

class ClicakbleCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    override var isSelected: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    func toggleIsHighlighted() {
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.alpha = self.isHighlighted ? 0.9 : 1.0
            self.transform = self.isHighlighted ?
                CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                CGAffineTransform.identity
        })
    }
}
 
// =================================================================================

enum CollectionDisplay {
    case mainItem
    case bribesImg
}

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var display: CollectionDisplay
    private var firstSetupDone = false
    let biometryType = Configs().biometricType()
    
    init(display: CollectionDisplay) {
        self.display = display
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        if !firstSetupDone {
            setup()
            firstSetupDone = true
        }
    }
    
    private func setup() {
        switch display {
        case .mainItem:
            //self.minimumLineSpacing = 8.0
            //            self.minimumInteritemSpacing = 15.0
            //self.scrollDirection = .vertical
            self.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.itemSize = CGSize(width: CGFloat((UIScreen.main.bounds.width-42)/2), height: CGFloat((UIScreen.main.bounds.width-42)/2))
        case .bribesImg:
            self.minimumLineSpacing = 0.0
            self.minimumInteritemSpacing = 0.0
            let height:CGFloat = (biometryType == .face ? 40 : 20) + 210
            self.scrollDirection = .vertical
            self.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            self.itemSize = CGSize(width: CGFloat(UIScreen.main.bounds.width-42), height: CGFloat(UIScreen.main.bounds.height-height))
        }
        
    }
}

