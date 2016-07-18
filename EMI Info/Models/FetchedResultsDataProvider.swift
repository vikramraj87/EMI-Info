import CoreData

class FetchedResultsDataProvider<ManagedObject: NSFetchRequestResult, Delegate: DataProviderDelegate where ManagedObject == Delegate.Object>: NSObject, DataProvider, NSFetchedResultsControllerDelegate {
    
    // MARK:-
    // MARK: Private stored properties
    private let fetchedResultsController: NSFetchedResultsController<ManagedObject>
    private var updates: [DataProviderUpdate<ManagedObject>] = []
    private weak var delegate: Delegate!
    
    init(fetchedResultsController: NSFetchedResultsController<ManagedObject>, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        self.fetchedResultsController.delegate = self
        
    }
    
    // MARK:-
    // MARK: DataProvider
    func numberOfObjectsInSection(_ section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return sectionInfo.numberOfObjects
    }
    
    func object(at indexPath: IndexPath) -> ManagedObject {
        return fetchedResultsController.object(at: indexPath)
    }
    
    func allObjects() -> [ManagedObject]? {
        return fetchedResultsController.fetchedObjects 
    }
    
    // MARK:-
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        updates = []
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: AnyObject, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else {
                fatalError("Indexpath not provided for insertion")
            }
            updates.append(.insert(indexPath))
        case .update:
            guard let indexPath = indexPath else {
                fatalError("Indexpath not provided for update")
            }
            updates.append(.update(indexPath, object(at: indexPath)))
        case .move:
            guard let indexPath = indexPath else {
                fatalError("Old Indexpath not provided for moving")
            }
            guard let newIndexPath = newIndexPath else {
                fatalError("New Indexpath not provided for moving")
            }
            updates.append(.move(indexPath, newIndexPath))
        case .delete:
            guard let indexPath = indexPath else {
                fatalError("Indexpath not provided for deletion")
            }
            updates.append(.delete(indexPath))
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate.dataProviderDidUpdate(with: updates)
    }
}
