import Foundation

protocol DataProviderDelegate: class {
    associatedtype Object
    
    func dataProviderDidUpdate(with updates: [DataProviderUpdate<Object>])
}
