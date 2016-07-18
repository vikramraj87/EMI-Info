import Foundation
import CoreData

protocol ConfiguredFetchResultProvider {
    associatedtype ManagedObject: NSFetchRequestResult
    
    static func sortedFetchResult() -> NSFetchRequest<ManagedObject>
}
