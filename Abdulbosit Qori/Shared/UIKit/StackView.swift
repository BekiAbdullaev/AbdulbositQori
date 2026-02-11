//
//  StackView.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/3/23.
//

import Foundation
import UIKit

class StackView: UIStackView {
    
    init(axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution, spacing: CGFloat, views: [UIView]? = nil) {
        super.init(frame: .zero)
        
        views?.forEach { addArrangedSubview($0) }
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
}
