//
//  GradientNode.swift
//  RainForestSwift
//
//  Created by Yaroslav Ermolaev on 19.10.2021.
//

import Foundation
import UIKit

class GradientNode:ASDisplayNode {
    class func draw(_ bounds: CGRect, withParameters parameters: NSObjectProtocol?, isCancelled isCancelledBlock: asdisplaynode_iscancelled_block_t, isRasterizing: Bool) {
        let myContext = UIGraphicsGetCurrentContext()
        myContext?.saveGState()
        myContext?.clip(to: bounds)

        let componentCount = 2

        let zero: CGFloat = 0.0
        let one: CGFloat = 1.0
        var locations = [zero, one]
        let components = [zero, zero, zero, one, zero, zero, zero, zero]

        let myColorSpace = CGColorSpaceCreateDeviceRGB()
        let myGradient = CGGradient(colorSpace: myColorSpace, colorComponents: components, locations: &locations, count: componentCount)

        let myStartPoint = CGPoint(x: bounds.midX, y: bounds.maxY)
        let myEndPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        if let myGradient = myGradient {
            myContext?.drawLinearGradient(myGradient, start: myStartPoint, end: myEndPoint, options: .drawsAfterEndLocation)
        }

        myContext?.restoreGState()
    }
}

