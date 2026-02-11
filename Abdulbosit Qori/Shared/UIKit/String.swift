//
//  String.swift
//  Abdulbosit Qori
//
//  Created by Bekzod Abdullaev on 3/3/23.
//

import UIKit
public extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}

extension String {
    static func generateFracktionAttributedString(title: String, fontSize: CGFloat = 20, fracTittle: String, textColor: UIColor = .black, lightTextColor: UIColor = .black.withAlphaComponent(0.8)) -> NSAttributedString {
        let regularFont = UIFont.systemFont(ofSize: fontSize * 0.75, weight: .regular)
        let boldFont = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
        
        let darkTextAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : textColor, NSAttributedString.Key.font : boldFont]
        let lightTextAttributes: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor : lightTextColor, NSAttributedString.Key.font : regularFont]
    
        let attributedString = NSMutableAttributedString()
        let wholePartAttributedString = NSMutableAttributedString(string: title, attributes: darkTextAttributes)
        let fractionalPartAttributedString = NSMutableAttributedString(string: " " + fracTittle, attributes: lightTextAttributes)
        
        attributedString.append(wholePartAttributedString)
        attributedString.append(fractionalPartAttributedString)
        return attributedString
    }

    
    static func setLineSpace(text:String, space:Int = 8) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(space)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
    static func setLineSpaceAttributed(attributedString:NSMutableAttributedString, space:Int = 8) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = CGFloat(space)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        return attributedString
    }
    
}
