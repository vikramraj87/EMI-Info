import Foundation

protocol DataProvider {
    associatedtype Object
    
    func numberOfObjectsInSection(_ section: Int) -> Int
    
    func object(at indexPath: IndexPath) -> Object
    
    func allObjects() -> [Object]?
}
