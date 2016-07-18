import Foundation

struct DecimalValidator: Validator {
    var breakChain = false
    
    let minimum: Double
    let maximum: Double
    let maximumFractionalPlaces: Int
    
    private let decimalSeparator: String = Locale.current.decimalSeparator
    
    private let disallowedCharacters: CharacterSet = {
        var allowedCharacters = "0123456789"
        allowedCharacters.append(Locale.current.decimalSeparator)
        return CharacterSet(charactersIn: allowedCharacters).inverted
    }()
    
    init(minimum: Double, maximum: Double, maximumFractionalPlaces: Int) {
        self.minimum = minimum
        self.maximum = maximum
        self.maximumFractionalPlaces = maximumFractionalPlaces
    }
    
    func validate(_ string: String) -> ValidationResult {
        if string.isEmpty {
            return .failure(.empty)
        }
        
        if string.rangeOfCharacter(from: disallowedCharacters) != nil {
            return .failure(.invalidCharacters)
        }
        
        if let rangeOfDecimal = string.range(of: decimalSeparator) {
            let rangeOfFractionalPart = string.index(after: rangeOfDecimal.lowerBound)..<string.endIndex
            
            let fractionalPart = string.substring(with: rangeOfFractionalPart)
            
            if fractionalPart.isEmpty {
                return .failure(.endsInDecimalSeparator)
            }

            if fractionalPart.range(of: decimalSeparator) != nil {
                return .failure(.moreThanOneDecimalSeparator)
            }
            
            if fractionalPart.characters.count > maximumFractionalPlaces {
                return .failure(.longerFraction)
            }
        }
        
        let number = Double(string)!
        
        if number < minimum {
            return .failure(.short)
        }

        if number > maximum {
            return .failure(.long)
        }
        
        return .success
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        if string.isEmpty {
            return .success
        }
        
        if string.rangeOfCharacter(from: disallowedCharacters) != nil {
            return .failure(.invalidCharacters)
        }
        
        var hasDecimal = false
        if let rangeOfDecimal = string.range(of: decimalSeparator) {
            hasDecimal = true
            
            let rangeOfFractionalPart = string.index(after: rangeOfDecimal.lowerBound)..<string.endIndex
            
            let fractionalPart = string.substring(with: rangeOfFractionalPart)
            
            if fractionalPart.range(of: decimalSeparator) != nil {
                return .failure(.moreThanOneDecimalSeparator)
            }
            
            if fractionalPart.characters.count > maximumFractionalPlaces {
                return .failure(.longerFraction)
            }
        }
        
        let number = Double(string)!
        
        if hasDecimal && number < minimum {
            return .failure(.short)
        }
        
        if number > maximum {
            return .failure(.long)
        }
        
        
        return .success
    }
}
