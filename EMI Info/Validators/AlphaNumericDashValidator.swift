import Foundation

struct NameValidator: Validator {
    var breakChain = false
    
    private let disallowedCharacters: CharacterSet = {
        let alphabets = CharacterSet.alphanumerics
        let others = CharacterSet(charactersIn: "-_ ")
        let allowedCharacters = others.union(alphabets)
        return allowedCharacters.inverted
    }()
    
    func validate(_ string: String) -> ValidationResult {
        if string.isEmpty {
            return .success
        }
        
        if string.rangeOfCharacter(from: disallowedCharacters) != nil {
            return .failure(.invalidCharacters)
        }
        
        return .success
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        return validate(string)
    }
}
