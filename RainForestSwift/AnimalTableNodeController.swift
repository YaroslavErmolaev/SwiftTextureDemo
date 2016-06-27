
import UIKit
import AsyncDisplayKit

class AnimalTableNodeController: ASViewController {
    var animals: [RainforestCardInfo]!
    let tableNode: ASTableNode!
    
    init(animals: [RainforestCardInfo]) {
        let tableNode = ASTableNode(style: .Plain)
        self.animals = animals
        self.tableNode = tableNode
        
        super.init(node: tableNode)
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ASTableDelegate

extension AnimalTableNodeController: ASTableDelegate {
    func tableView(tableView: ASTableView, willBeginBatchFetchWithContext context: ASBatchContext) {
        nextPageWithCompletion { (results) in
            self.insertNewRows(results)
            context.completeBatchFetching(true)
        }
    }
    
    func shouldBatchFetchForTableView(tableView: ASTableView) -> Bool {
        return true
    }
}

// MARK: - ASTableDataSource

extension AnimalTableNodeController: ASTableDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(tableView: ASTableView, nodeBlockForRowAtIndexPath indexPath: NSIndexPath) -> ASCellNodeBlock {
        let animal = animals[indexPath.row]
        
        return {
            let node = CardCellNode(animalInfo: animal)
            node.preferredFrameSize = UIScreen.mainScreen().bounds.size
            return node
        }
    }
}

// MARK: - Helpers

extension AnimalTableNodeController {
    func nextPageWithCompletion(block: (results: [RainforestCardInfo]) -> ()) {
        let moreAnimals = Array(self.animals[0 ..< 5])
        
        dispatch_async(dispatch_get_main_queue()) {
            block(results: moreAnimals)
        }
    }
    
    func insertNewRows(newAnimals: [RainforestCardInfo]) {
        let section = 0
        var indexPaths = [NSIndexPath]()
        
        let newTotalNumberOfPhotos = animals.count + newAnimals.count
        
        for row in animals.count ..< newTotalNumberOfPhotos {
            let path = NSIndexPath(forRow: row, inSection: section)
            indexPaths.append(path)
        }
        
        animals.appendContentsOf(newAnimals)
        if let tableView = node.view as? ASTableView {
            tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .None)
        }
    }
}
