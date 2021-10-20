
import UIKit
import AsyncDisplayKit

class CardCellNode: ASCellNode {
    let animalInfo: RainforestCardInfo
    
    fileprivate let backgroundImageNode: ASImageNode
    fileprivate let animalImageNode: ASNetworkImageNode
    
    fileprivate let animalNameTextNode: ASTextNode
    fileprivate let animalDescriptionTextNode: ASTextNode
    
    fileprivate let gradientNode: GradientNode
    
    init(animalInfo: RainforestCardInfo) {
        self.animalInfo = animalInfo
        
        backgroundImageNode = ASImageNode()
        animalImageNode     = ASNetworkImageNode()
        
        animalNameTextNode        = ASTextNode()
        animalDescriptionTextNode = ASTextNode()
        
        gradientNode = GradientNode()
        
        super.init()
        
        backgroundColor = UIColor.lightGray
        clipsToBounds = true
        
        //Animal Image
        animalImageNode.url = animalInfo.imageURL
        animalImageNode.clipsToBounds = true
        animalImageNode.delegate = self
        animalImageNode.placeholderFadeDuration = 0.15
        animalImageNode.contentMode = .scaleAspectFill
        animalImageNode.shouldRenderProgressImages = true
        
        //Animal Name
        animalNameTextNode.attributedText = NSAttributedString(forTitleText: animalInfo.name)
        animalNameTextNode.placeholderEnabled = true
        animalNameTextNode.placeholderFadeDuration = 0.15
        animalNameTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
        
        //Animal Description
        animalDescriptionTextNode.attributedText = NSAttributedString(forDescription: animalInfo.animalDescription)
        animalDescriptionTextNode.truncationAttributedText = NSAttributedString(forDescription: "…")
        animalDescriptionTextNode.backgroundColor = UIColor.clear
        animalDescriptionTextNode.placeholderEnabled = true
        animalDescriptionTextNode.placeholderFadeDuration = 0.15
        animalDescriptionTextNode.placeholderColor = UIColor(white: 0.777, alpha: 1.0)
        
        //Background Image
        backgroundImageNode.placeholderFadeDuration = 0.15
        backgroundImageNode.imageModificationBlock = { image, _ in
            let newImage = image.applyBlur(withRadius: 30, tintColor: UIColor(white: 0.5, alpha: 0.3),
                                           saturationDeltaFactor: 1.8,
                                           maskImage: nil, didCancel: {
                return false
            })
            return (newImage != nil) ? newImage : image
        }
        
        //Gradient Node
        gradientNode.isLayerBacked = true
        gradientNode.isOpaque = false
        
        addSubnode(backgroundImageNode)
        addSubnode(animalImageNode)
        addSubnode(gradientNode)
        
        addSubnode(animalNameTextNode)
        addSubnode(animalDescriptionTextNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let ratio = (constrainedSize.min.height)/constrainedSize.max.width;
        
        let imageRatioSpec = ASRatioLayoutSpec(ratio: ratio, child: animalImageNode)
        let gradientOverlaySpec = ASOverlayLayoutSpec(child: imageRatioSpec, overlay: gradientNode)
        let relativeSpec = ASRelativeLayoutSpec(horizontalPosition: .start, verticalPosition: .end, sizingOption: [], child: animalNameTextNode)
        let nameInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 0), child: relativeSpec)
        
        let nameOverlaySpec = ASOverlayLayoutSpec(child: gradientOverlaySpec, overlay: nameInsetSpec)
        
        let descriptionTextInsetSpec = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16.0, left: 28.0, bottom: 12.0, right: 28.0), child: animalDescriptionTextNode)
        
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start, alignItems: .start, children: [nameOverlaySpec, descriptionTextInsetSpec])
        
        let backgroundLayoutSpec = ASBackgroundLayoutSpec(child: verticalStackSpec, background: backgroundImageNode)
        
        return backgroundLayoutSpec
    }
}

// MARK: - ASNetworkImageNodeDelegate

extension CardCellNode: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        backgroundImageNode.image = image
    }
}

extension CardCellNode {
    override func didEnterVisibleState() {
        super.didEnterVisibleState()
      print("\(self.debugName ?? "UNKNOWN") is visible!");
    }

    override func didExitVisibleState() {
      super.didExitVisibleState()
      print("\(self.debugName ?? "UNKNOWN") left the screen");
    }

    override func didEnterDisplayState() {
      super.didEnterDisplayState()
      print("\(self.debugName ?? "UNKNOWN") has started rendering!");
    }

    override func didExitDisplayState() {
      super.didExitDisplayState()
      print("\(self.debugName ?? "UNKNOWN") has left the view display state.");
    }

    override func didEnterPreloadState() {
      super.didEnterPreloadState()
      print("\(self.debugName ?? "UNKNOWN") is loading data!");
    }

    override func didExitPreloadState() {
      super.didExitPreloadState()
      print("\(self.debugName ?? "UNKNOWN") has left the data loading range.");
    }

}
