import Foundation

struct DigitsValidator: Validator {
    var breakChain = false
    
    let minimumLength: Int
    let maximumLength: Int
    
    private let disallowedCharacters: CharacterSet = CharacterSet(charactersIn: "0123456789").inverted
    
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
        
        if string.rangeOfCharacter(from: disallowedCharacters) != nil {
            return .failure(.invalidCharacters)
        }
        
        return .success
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        if string.characters.count > maximumLength {
            return .failure(.long)
        }
        
        if string.rangeOfCharacter(from: disallowedCharacters) != nil {
            return .failure(.invalidCharacters)
        }
        return .success
    }
}
