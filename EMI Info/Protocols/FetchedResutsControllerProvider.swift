import Foundation
import CoreData

protocol FetchedResultsControllerProvider: ManagedObjectContextConsumer {
    associatedtype FetchResultProvider: ConfiguredFetchResultProvider
    
    func fetchedResultsController(withConfigurationHandler handler: ((NSFetchRequest<FetchResultProvider.ManagedObject>) -> Void)?) -> NSFetchedResultsController<FetchResultProvider.ManagedObject>
}

extension FetchedResultsControllerProvider {
    func fetchedResultsController(withConfigurationHandler handler: ((NSFetchRequest<FetchResultProvider.ManagedObject>) -> Void)?) -> NSFetchedResultsController<FetchResultProvider.ManagedObject> {
        let fetchRequest = FetchResultProvider.sortedFetchResult()
        
        handler?(fetchRequest)
        
        let fetchedResultsController: NSFetchedResultsController<FetchResultProvider.ManagedObject> = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return fetchedResultsController
    }
}

