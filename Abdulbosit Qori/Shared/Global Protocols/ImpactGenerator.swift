//
//  ImpactGenerator.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/6/23.
//

import Foundation
import UIKit

enum ImpactGenerator {
    case panModal
    func generateImpact() {
        switch self {
        case .panModal:
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
}
