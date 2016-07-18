import Foundation

struct RequiredValidator: Validator {
    var breakChain = true
    
    func validate(_ string: String) -> ValidationResult {
        if string.isEmpty {
            return .failure(.empty)
        }
        
        return .success
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        // Live validation in required validation will always be successful
        return .success
    }
}
