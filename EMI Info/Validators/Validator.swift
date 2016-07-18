import Foundation

protocol Validator {
    var breakChain: Bool { get set }

    func validate(_ string: String) -> ValidationResult
    
    func liveValidate(incompleteString string: String) -> ValidationResult
}
