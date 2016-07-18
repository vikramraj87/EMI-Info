import Foundation
import CoreData

protocol ManagedObjectContextConsumer {
    var managedObjectContext: NSManagedObjectContext! { get set }
    
    func saveContext()
}

extension ManagedObjectContextConsumer {
    func saveContext() {
        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
