import Foundation

struct IntegerValidator: Validator {
    var breakChain = false
    
    let minimum: Int
    let maximum: Int
    
    init(minimum: Int, maximum: Int) {
        self.minimum = minimum
        self.maximum = maximum
    }
    
    private let disallowedCharacters = CharacterSet(charactersIn: "0123456789").inverted
    
    func validate(_ string: String) -> ValidationResult {
        if string.rangeOfCharacter(from: disallowedCharacters) != nil {
            return .failure(.invalidCharacters)
        }
        
        let number = Int(string)!
        
        if number < minimum {
            return .failure(.short)
        }

        if number > maximum {
            return .failure(.long)
        }
        
        return .success
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        if string.rangeOfCharacter(from: disallowedCharacters) != nil {
            return .failure(.invalidCharacters)
        }
        
        let number = Int(string)!
        
        if number > maximum {
            return .failure(.long)
        }
        
        return .success
    }
}
