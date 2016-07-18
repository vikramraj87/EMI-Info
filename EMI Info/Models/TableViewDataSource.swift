import UIKit

protocol TableViewDataSourceDelegate: class {
    associatedtype Object
    
    func cellIdentifier(for object: Object) -> String
}

/// TableViewDataSource
class TableViewDataSource<Object, Provider: DataProvider, Cell: ConfigurableCell, Delegate: TableViewDataSourceDelegate where Object == Provider.Object, Cell: UITableViewCell, Cell.Object == Object, Delegate.Object == Object>: NSObject, UITableViewDataSource {
    
    private let dataProvider: Provider
    private let tableView: UITableView
    private weak var delegate: Delegate!
    
    init(tableView: UITableView, dataProvider: Provider, delegate: Delegate) {
        self.tableView = tableView
        self.dataProvider = dataProvider
        self.delegate = delegate
        super.init()
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.numberOfObjectsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = dataProvider.object(at: indexPath)
        let identifier = delegate.cellIdentifier(for: object)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Unexpected cell type at \(indexPath)")
        }
        cell.configure(for: object)
        return cell
    }
    
    func processUpdates(_ updates: [DataProviderUpdate<Object>]) {
        tableView.beginUpdates()
        
        for update in updates {
            switch update {
            case .insert(let indexPath):
                tableView.insertRows(at: [indexPath], with: .fade)
            case .update(let indexPath, let object):
                guard let cell = tableView.cellForRow(at: indexPath) as? Cell else {
                    fatalError("Unexpected table view cell")
                }
                cell.configure(for: object)
            case .move(let oldIndexPath, let newIndexPath):
                tableView.deleteRows(at: [oldIndexPath], with: .fade)
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .delete(let indexPath):
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
        
        tableView.endUpdates()
    }
    
    func object(for cell: Cell) -> Object? {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return nil
        }
        return dataProvider.object(at: indexPath)
    }
}
