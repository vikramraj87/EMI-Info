import UIKit

extension UIView {
    func superviewWithClassName(_ className: String) -> UIView? {
        guard let classType = NSClassFromString(className) else {
            return nil
        }
        
        var view: UIView? = self
        while(view != nil) {
            if view!.isKind(of: classType) {
                return view!
            }
            view = view!.superview
        }
        
        return nil
    }
}
