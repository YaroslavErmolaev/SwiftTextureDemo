////
////  UIImage+ImageEffects.swift
////  RainForestSwift
////
////  Created by Yaroslav Ermolaev on 19.10.2021.
////
//
////  Converted to Swift 5.5 by Swiftify v5.5.22755 - https://swiftify.com/
//import UIKit
//import Accelerate
//import AsyncDisplayKit
//
//extension UIImage {
//
////    func applyBlur(withRadius blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage?) -> UIImage? {
////        return applyBlur(withRadius: blurRadius, tintColor: tintColor, saturationDeltaFactor: saturationDeltaFactor, maskImage: maskImage, didCancel: {
////            return false
////        })
////    }
//
//    func applyBlur(withRadius blurRadius: CGFloat, tintColor: UIColor?, saturationDeltaFactor: CGFloat, maskImage: UIImage?, didCancel: @escaping () -> Bool) -> UIImage? {
//        // Check pre-conditions.
//        if size.width < 1 || size.height < 1 {
//            return nil
//        }
//        if cgImage == nil {
//            return nil
//        }
//        if maskImage != nil && maskImage?.cgImage == nil {
//            return nil
//        }
//
//        //@autoreleasepool do {
//        //autoreleasepool {
//
//        let imageRect = CGRect(origin: CGPoint.zero, size: size)
//        var effectImage = self
//
//        let hasBlur = blurRadius > .ulpOfOne
//        let hasSaturationChange = abs(saturationDeltaFactor - 1.0) > .ulpOfOne
//
//        var effectInBuffer = vImage_Buffer()
//        var effectOutBuffer = vImage_Buffer()
//
//        if hasBlur || hasSaturationChange {
//            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//            let effectInContext = UIGraphicsGetCurrentContext()
//            effectInContext?.scaleBy(x: 1.0, y: -1.0)
//            effectInContext?.translateBy(x: 0, y: -size.height)
//            effectInContext?.draw(self.cgImage!, in: imageRect)
//
//            effectInBuffer.data = effectInContext?.data
//            effectInBuffer.width = vImagePixelCount(effectInContext?.width ?? 0)
//            effectInBuffer.height = vImagePixelCount(effectInContext?.height ?? 0)
//            effectInBuffer.rowBytes = effectInContext?.bytesPerRow ?? 0
//
//            UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//            let effectOutContext = UIGraphicsGetCurrentContext()
//            effectOutBuffer.data = effectOutContext?.data
//            effectOutBuffer.width = vImagePixelCount(effectOutContext?.width ?? 0)
//            effectOutBuffer.height = vImagePixelCount(effectOutContext?.height ?? 0)
//            effectOutBuffer.rowBytes = effectOutContext?.bytesPerRow ?? 0
//
//            if hasBlur {
//                // A description of how to compute the box kernel width from the Gaussian
//                // radius (aka standard deviation) appears in the SVG spec:
//                // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
//                //
//                // For larger values of 's' (s >= 2.0), an approximation can be used: Three
//                // successive box-blurs build a piece-wise quadratic convolution kernel, which
//                // approximates the Gaussian kernel to within roughly 3%.
//                //
//                // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
//                //
//                // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
//                //
//                let inputRadius: CGFloat = (blurRadius * UIScreen.main.scale) * 3.0 * sqrt(2 * .pi)
//                var radius: UInt32 = UInt32(floor(inputRadius / 4 + 0.5))
//                if radius % 2 != 1 {
//                    radius += 1 // force radius to be odd so that the three box-blur methodology works.
//                }
//
//                if didCancel() {
//                    UIGraphicsEndImageContext()
//                    UIGraphicsEndImageContext()
//                    return nil
//                }
//
//                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, vImagePixelCount(0), vImagePixelCount(0), radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
//
//                if didCancel() {
//                    UIGraphicsEndImageContext()
//                    UIGraphicsEndImageContext()
//                    return nil
//                }
//
//                vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, nil, vImagePixelCount(0), vImagePixelCount(0), radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
//
//                if didCancel() {
//                    UIGraphicsEndImageContext()
//                    UIGraphicsEndImageContext()
//                    return nil
//                }
//
//                vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, nil, vImagePixelCount(0), vImagePixelCount(0), radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
//
//            }
//
//            if didCancel() {
//                UIGraphicsEndImageContext()
//                UIGraphicsEndImageContext()
//                return nil
//            }
//
//
//            var effectImageBuffersAreSwapped = false
//            if hasSaturationChange {
//                let s = saturationDeltaFactor
//                let floatingPointSaturationMatrix = [0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0, 0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0, 0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0, 0, 0, 0, 1]
//                let divisor: Float = 256
//                let matrixSize = MemoryLayout.size(ofValue: floatingPointSaturationMatrix) / MemoryLayout.size(ofValue: floatingPointSaturationMatrix[0])
//                var saturationMatrix = [Int16](repeating: 0, count: matrixSize)
//                for i in 0..<matrixSize {
//                    saturationMatrix[i] = Int16(roundf(Float(floatingPointSaturationMatrix[i]) * divisor))
//                }
//                if hasBlur {
//                    vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, &saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
//                    effectImageBuffersAreSwapped = true
//                } else {
//                    vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, &saturationMatrix, Int32(divisor), nil, nil, vImage_Flags(kvImageNoFlags))
//                }
//            }
//            if !effectImageBuffersAreSwapped {
//                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
//            }
//            UIGraphicsEndImageContext()
//
//            if effectImageBuffersAreSwapped {
//                effectImage = UIGraphicsGetImageFromCurrentImageContext()!
//            }
//            UIGraphicsEndImageContext()
//        }
//
//        // Set up output context.
//        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
//        let outputContext = UIGraphicsGetCurrentContext()
//        outputContext?.scaleBy(x: 1.0, y: -1.0)
//        outputContext?.translateBy(x: 0, y: -size.height)
//
//        // Draw base image.
//        outputContext?.draw(self.cgImage!, in:imageRect)
//
//        // Draw effect image.
//        if hasBlur {
//            outputContext?.saveGState()
//            if (maskImage != nil) {
//                if let CGImageMasK = maskImage!.cgImage {
//                    outputContext?.clip(to: imageRect, mask: CGImageMasK)
//                }
//            }
//            outputContext?.draw(effectImage.cgImage!, in: imageRect)
//            outputContext?.restoreGState()
//        }
//
//        // Add in color tint.
//        if let tintColor = tintColor {
//            outputContext?.saveGState()
//            outputContext?.setFillColor(tintColor.cgColor)
//            outputContext?.fill(imageRect)
//            outputContext?.restoreGState()
//        }
//
//        // Output image is ready.
//        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return outputImage
//        //}
//    }
//
//    class func resize(_ image: UIImage?, newSize: CGSize) -> UIImage? {
//        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
//        let imageRef = image?.cgImage
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
//        let context = UIGraphicsGetCurrentContext()!
//
//        // Set the quality level to use when rescaling
//        context.interpolationQuality = CGInterpolationQuality.high
//        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
//
//        context.concatenate(flipVertical)
//        // Draw into the context; this scales the image
//        context.draw(imageRef!, in: newRect)
//
//        // Get the resized image from the context and a UIImage
//        let newImageRef = context.makeImage()
//        var newImage: UIImage? = nil
//        if let newImageRef = newImageRef {
//            newImage = UIImage(cgImage: newImageRef)
//        }
//
//        //CGImageRelease(newImageRef!)
//        UIGraphicsEndImageContext()
//
//        return newImage
//    }
//}
