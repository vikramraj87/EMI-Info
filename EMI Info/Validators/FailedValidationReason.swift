import Foundation

enum FailedValidationReason: String {
    case empty
    case short
    case long
    case invalidCharacters
    
    // DecimalValidatorTests
    case longerFraction
    case endsInDecimalSeparator
    case moreThanOneDecimalSeparator
}
