
import UIKit
import AsyncDisplayKit

class CardCellNode: ASCellNode {
    let animalInfo: RainforestCardInfo
    
    private let backgroundImageNode: ASImageNode
    private let animalImageNode: ASNetworkImageNode
    
    private let animalNameTextNode: ASTextNode
    private let animalDescriptionTextNode: ASTextNode
    
    private let gradientNode: GradientNode
    
    init(animalInfo: RainforestCardInfo) {
        self.animalInfo = animalInfo
        
        backgroundImageNode = ASImageNode()
        animalImageNode     = ASNetworkImageNode()
        
        animalNameTextNode        = ASTextNode()
        animalDescriptionTextNode = ASTextNode()
        
        gradientNode = GradientNode()
        
        super.init()
        
        backgroundColor = UIColor.lightGrayColor()
        clipsToBounds = true
        
        //Animal Image
        animalImageNode.URL = animalInfo.imageURL
        animalImageNode.clipsToBounds = true
        animalImageNode.delegate = self
        animalImageNode.placeholderFadeDuration = 0.15
        animalImageNode.contentMode = .ScaleAspectFill
        animalImageNode.shouldRenderProgressImages = true
        
        //Animal Name
        animalNameTextNode.attributedString = NSAttributedString(forTitleText: animalInfo.name)
        
        //Animal Description
        animalDescriptionTextNode.attributedString = NSAttributedString(forDescription: animalInfo.animalDescription)
        animalDescriptionTextNode.truncationAttributedString = NSAttributedString(forDescription: "…")
        animalDescriptionTextNode.backgroundColor = UIColor.clearColor()
        
        //Background Image
        backgroundImageNode.placeholderFadeDuration = 0.15
        backgroundImageNode.imageModificationBlock = { image in
            let newImage = image.applyBlurWithRadius(30, tintColor: UIColor(white: 0.5, alpha: 0.3), saturationDeltaFactor: 1.8, maskImage: nil)
            return (newImage != nil) ? newImage : image
        }
        
        //Gradient Node
        gradientNode.layerBacked = true
        gradientNode.opaque = false
        
        addSubnode(backgroundImageNode)
        addSubnode(animalImageNode)
        addSubnode(gradientNode)
        
        addSubnode(animalNameTextNode)
        addSubnode(animalDescriptionTextNode)
    }
    
    override func layoutSpecThatFits(constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio: CGFloat = (preferredFrameSize.height * (2.0/3.0))/preferredFrameSize.width
        animalDescriptionTextNode.preferredFrameSize = CGSize(width: preferredFrameSize.width, height: preferredFrameSize.height * (1.0/3.0))

        let imageRatioSpec = ASRatioLayoutSpec(ratio: ratio, child: animalImageNode)
        let gradientOverlaySpec = ASOverlayLayoutSpec(child: imageRatioSpec, overlay: gradientNode)
        let nameInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, 16, 8, 0), child: animalNameTextNode)
        
        let imageVerticalStackSpec = ASStackLayoutSpec(direction: .Vertical, spacing: 0, justifyContent: .End, alignItems: .Start, children: [nameInsetSpec])

        let titleOverlaySpec = ASOverlayLayoutSpec(child: gradientOverlaySpec, overlay: imageVerticalStackSpec)

        let descriptionTextInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsetsMake(16.0, 28.0, 12.0, 28.0), child: animalDescriptionTextNode)
        
        let verticalStackSpec = ASStackLayoutSpec(direction: .Vertical, spacing: 0, justifyContent: .Start, alignItems: .Start, children: [titleOverlaySpec, descriptionTextInsetSpec])

        let backgroundLayoutSpec = ASBackgroundLayoutSpec(child: verticalStackSpec, background: backgroundImageNode)

        return backgroundLayoutSpec
    }
    
    
}

// MARK: - ASNetworkImageNodeDelegate

extension CardCellNode: ASNetworkImageNodeDelegate {
    func imageNode(imageNode: ASNetworkImageNode, didFailWithError error: NSError) {
        
    }
    
    func imageNode(imageNode: ASNetworkImageNode, didLoadImage image: UIImage) {
        backgroundImageNode.image = image
    }
}
