import Foundation
import CoreData

extension EMI: ConfiguredFetchResultProvider {
    typealias ManagedObject = EMI
    
    static func sortedFetchResult() -> NSFetchRequest<ManagedObject> {
        let fetchRequest: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        
        let sortDescriptor = SortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fetchRequest
    }
}



