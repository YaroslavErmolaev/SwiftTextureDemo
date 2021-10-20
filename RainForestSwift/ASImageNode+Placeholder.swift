//
//  ASImageNode+Placeholder.swift
//  RainForestSwift
//
//  Created by Yaroslav Ermolaev on 19.10.2021.
//

import Foundation
import UIKit
import AsyncDisplayKit

extension ASImageNode {
    static let placeholderImageVar: UIImage? = {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: 10, height: 10), false, 0.0)
            let context = UIGraphicsGetCurrentContext();
            context?.setFillColor(UIColor.lightGray.cgColor)
            context?.fill(CGRect(x: 0, y: 0, width: 10, height: 10))
            var placeholderImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return placeholderImage
    }()

    open override func placeholderImage() -> UIImage? {
        return ASImageNode.placeholderImageVar
    }
}
