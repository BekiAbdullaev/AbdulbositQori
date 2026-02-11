//
//  MyImage.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/17/23.
//

import Foundation
import UIKit

class MyImage: UIImageView {
    
    init(cornerRadius: CGFloat? = nil, imageName:String? = "") {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius ?? 0
        contentMode = .scaleAspectFit
        self.image = UIImage(named: imageName ?? "")
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
