import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier
    
    func performSegue(with identifier: SegueIdentifier)
}

extension SegueHandlerType where Self:UIViewController, SegueIdentifier.RawValue == String {
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard let identifierString = segue.identifier,
            let identifier = SegueIdentifier(rawValue: identifierString)
        else {
            fatalError("Unknown segue: \(segue) with identifier: \(segue.identifier)")
        }
        return identifier
    }
    
    func performSegue(with identifier: SegueIdentifier) {
        performSegue(withIdentifier: identifier.rawValue, sender: nil)
    }
}

