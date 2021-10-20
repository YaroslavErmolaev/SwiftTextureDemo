
import UIKit
import AsyncDisplayKit

class ViewController: UIViewController {
    let pagerNode = ASPagerNode()
    let allAnimals = [RainforestCardInfo.birdCards(),
                      RainforestCardInfo.mammalCards(),
                      RainforestCardInfo.reptileCards()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pagerNode.setDataSource(self)
        
        self.view.addSubnode(pagerNode)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.pagerNode.frame = self.view.bounds
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

// MARK: - ASPagerDataSource

extension ViewController: ASPagerDataSource {
    func pagerNode(_ pagerNode: ASPagerNode, nodeAt index: Int) -> ASCellNode {
        let animals = allAnimals[index]
        
        let node = ASCellNode(viewControllerBlock: {
            return AnimalTableNodeController(animals: animals) as UIViewController
        }, didLoad: nil)
        
        return node
    }
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return allAnimals.count
    }
}

