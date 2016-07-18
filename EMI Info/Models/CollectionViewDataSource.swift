import UIKit

protocol CollectionViewDataSourceDelegate: class {
    associatedtype Object
    
    func cellIdentifier(for object: Object) -> String
    
    func headerView(for indexPath: IndexPath) -> UICollectionReusableView
}

class CollectionViewDataSource<Object, Provider: DataProvider, Cell: ConfigurableCell, DataSourceDelegate: CollectionViewDataSourceDelegate where Provider.Object == Object, Cell: UICollectionViewCell, Cell.Object == Object, DataSourceDelegate.Object == Object>: NSObject, UICollectionViewDataSource {
    private let dataProvider: Provider
    private let collectionView: UICollectionView
    private weak var dataSourceDelegate: DataSourceDelegate!
    
    init(collectionView: UICollectionView, dataProvider: Provider, cellIdentifierProvider: DataSourceDelegate) {
        self.dataProvider = dataProvider
        self.collectionView = collectionView
        self.dataSourceDelegate = cellIdentifierProvider
        super.init()
        collectionView.dataSource = self
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataProvider.numberOfObjectsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let object = dataProvider.object(at: indexPath)
        let identifier = dataSourceDelegate.cellIdentifier(for: object)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        cell.configure(for: object)
        return cell
    }
    
    func processUpdates(_ updates: [DataProviderUpdate<Object>]) {
        for update in updates {
            switch update {
            case .insert(let indexPath):
                collectionView.insertItems(at: [indexPath])
            case .update(let indexPath, let object):
                guard let cell = collectionView.cellForItem(at: indexPath) as? Cell else {
                    fatalError("Unexpected collection view cell")
                }
                cell.configure(for: object)
            case .move(let oldIndexPath, let newIndexPath):
                collectionView.deleteItems(at: [oldIndexPath])
                collectionView.insertItems(at: [newIndexPath])
            case .delete(let indexPath):
                collectionView.deleteItems(at: [indexPath])
            }
        }
    }
    
    func object(for cell: Cell) -> Object? {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return nil
        }
        return dataProvider.object(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return dataSourceDelegate.headerView(for: indexPath)
    }
    
}
