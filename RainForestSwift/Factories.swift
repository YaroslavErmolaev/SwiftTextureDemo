//
//  Factories.swift
//  RainForestSwift
//
//  Created by Yaroslav Ermolaev on 19.10.2021.
//

import Foundation
import UIKit

extension NSAttributedString {
    convenience init?(forTitleText text: String?) {
        var titleAttributes: [NSAttributedString.Key : Any]? = nil
        if let font = UIFont(name: "AvenirNext-Heavy", size: 30), let title = NSShadow.titleText(), let justified = NSParagraphStyle.justified() {
            titleAttributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.shadow: title,
                NSAttributedString.Key.paragraphStyle: justified
            ]
        }

        self.init(string: text ?? "", attributes: titleAttributes)
    }

    convenience init?(forDescription text: String?) {
        var descriptionAttributes: [NSAttributedString.Key : Any]? = nil
        if let font = UIFont(name: "AvenirNext-Medium", size: 16), let description = NSShadow.descriptionText(), let justified = NSParagraphStyle.justified() {
            descriptionAttributes = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.backgroundColor: UIColor.clear,
                NSAttributedString.Key.shadow: description,
                NSAttributedString.Key.paragraphStyle: justified
            ]
        }

        self.init(string: text ?? "", attributes: descriptionAttributes)
    }
}

extension NSParagraphStyle {
    class func justified() -> NSParagraphStyle? {
        let paragraphStlye = NSMutableParagraphStyle()
        paragraphStlye.alignment = .justified
        return paragraphStlye
    }
}

extension NSShadow {
    class func titleText() -> NSShadow? {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 2)
        shadow.shadowBlurRadius = 3.0

        return shadow
    }

    class func descriptionText() -> NSShadow? {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor(white: 0.0, alpha: 0.3)
        shadow.shadowOffset = CGSize(width: 0, height: 1)
        shadow.shadowBlurRadius = 3.0

        return shadow
    }
}
