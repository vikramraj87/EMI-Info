import Foundation

struct StringLengthValidator: Validator {
    var breakChain = false
    
    let minimumLength: Int
    let maximumLength: Int
    
    init(minimumLength: Int, maximumLength: Int) {
        self.minimumLength = minimumLength
        self.maximumLength = maximumLength
    }
    
    func validate(_ string: String) -> ValidationResult {
        if string.characters.count < minimumLength {
            return .failure(.short)
        }
        
        if string.characters.count > maximumLength {
            return .failure(.long)
        }
        
        return .success
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        if string.characters.count <= maximumLength {
            return .success
        }
        return .failure(.long)
    }
}
