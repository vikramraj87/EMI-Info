import Foundation

enum ValidationResult: Equatable {
    case success
    case failure(FailedValidationReason)
}

func ==(lhs: ValidationResult, rhs: ValidationResult) -> Bool {
    switch (lhs, rhs) {
    case (.success, .success):
        return true
    case (.failure(let lhsReason), .failure(let rhsReason)):
        return lhsReason == rhsReason
    default:
        return false
    }
}
