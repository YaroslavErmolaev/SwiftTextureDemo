
import UIKit
import AsyncDisplayKit

class ViewController: UIViewController {
    let pagerNode = ASPagerNode()
    let allAnimals = [RainforestCardInfo.birdCards(), RainforestCardInfo.mammalCards(), RainforestCardInfo.reptileCards()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerNode.setDataSource(self)
        
        self.view.addSubnode(pagerNode)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.pagerNode.frame = self.view.bounds
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

// MARK: - ASPagerDataSource

extension ViewController: ASPagerDataSource {
    func pagerNode(pagerNode: ASPagerNode!, nodeAtIndex index: Int) -> ASCellNode! {
        let animals = allAnimals[index]

        let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
            return AnimalTableNodeController(animals: animals)
        }, didLoadBlock: nil)

        node.preferredFrameSize = pagerNode.bounds.size
        
        return node
    }

    func numberOfPagesInPagerNode(pagerNode: ASPagerNode!) -> Int {
        return allAnimals.count
    }
}

