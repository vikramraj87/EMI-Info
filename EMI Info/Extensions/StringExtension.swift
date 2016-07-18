import Foundation

extension String {
    func containsOnly(charactersIn string: String) -> Bool {
        let disallowedCharacterSet = NSCharacterSet(charactersIn: string).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
}
