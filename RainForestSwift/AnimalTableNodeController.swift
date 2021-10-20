
import UIKit
import AsyncDisplayKit

class AnimalTableNodeController: ASDKViewController<ASDisplayNode> {
    var animals: [RainforestCardInfo]!
    let tableNode: ASTableNode!
    
    init(animals: [RainforestCardInfo]) {
        let tableNode = ASTableNode()
        
        self.animals = animals
        self.tableNode = tableNode
        
        super.init(node: tableNode)
        
        self.tableNode.delegate = self
        self.tableNode.dataSource = self
        
        self.tableNode.view.separatorStyle = .none
        //Установка leadingScreensForBatching в 1.0 означает, что вы хотите, чтобы новые пакеты были загружены каждый раз, когда пользователь прокрутил к точке, где до конца таблицы остался лишь 1 элемент.
        self.tableNode.leadingScreensForBatching = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ASTableDelegate

extension AnimalTableNodeController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
        nextPageWithCompletion { (results) in
            self.insertNewRows(results)
            context.completeBatchFetching(true)
        }
    }
    /*
     Этот метод нужен для того, чтобы сказать таблице, должна ли она продолжить выполнять запросы для загрузки новых пакетов. Если вы знаете, что загружать больше нечего – верните NO.
     Если вы действительно хотите, чтобы эта таблица скроллилась бесконечно, просто верните YES, чтобы гарантировать, что всегда будут запрашиваться новые пакеты.
     */
    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
        return true
    }
}

// MARK: - ASTableDataSource

extension AnimalTableNodeController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
        let animal = animals[indexPath.row]
        
        return {
            let node = CardCellNode(animalInfo: animal)
            node.debugName = "CELL:\(indexPath.row)"
            return node
        }
    }
    
    @objc(tableNode:constrainedSizeForRowAtIndexPath:)
    func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
        let min = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height/3.0 * 2.0)
        let max = CGSize(width: UIScreen.main.bounds.size.width, height: CGFloat.greatestFiniteMagnitude)
        return ASSizeRange(min: min, max: max)
    }
}

// MARK: - Helpers

extension AnimalTableNodeController {
    func nextPageWithCompletion(_ block: @escaping (_ results: [RainforestCardInfo]) -> ()) {
        let moreAnimals = Array(self.animals[0 ..< 5])
        
        DispatchQueue.main.async {
            block(moreAnimals)
        }
    }
    
    func insertNewRows(_ newAnimals: [RainforestCardInfo]) {
        let section = 0
        var indexPaths = [IndexPath]()
        
        let newTotalNumberOfPhotos = animals.count + newAnimals.count
        
        for row in animals.count ..< newTotalNumberOfPhotos {
            let path = IndexPath(row: row, section: section)
            indexPaths.append(path)
        }
        
        animals.append(contentsOf: newAnimals)
        if let tableNode = node as? ASTableNode {
            tableNode.insertRows(at: indexPaths, with: .none)
        }
    }
}
