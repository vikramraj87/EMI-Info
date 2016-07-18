import Foundation

struct ValidatorChain {
    var validators: [Validator] = []
    
    private (set) var failedValidators: [(Validator, FailedValidationReason)]  = []
    
    private (set) var failedLiveValidators: [(Validator, FailedValidationReason)] = []
    
    init(validators: [Validator]) {
        self.validators = validators
    }
    
    mutating func validate(_ string: String) -> Bool {
        var validationFailed = false
        failedValidators = []
        
        for validator in validators {
            let result = validator.validate(string)
            
            if case .failure(let reason) = result {
                failedValidators.append((validator, reason))
                validationFailed = true
                
                if validator.breakChain {
                    break
                }
            }
        }
        
        return !validationFailed
    }
    
    mutating func liveValidate(incompleteString string: String) -> Bool {
        var validationFailed = false
        failedLiveValidators = []
        
        for validator in validators {
            let result = validator.liveValidate(incompleteString: string)
            
            if case .failure(let reason) = result {
                failedLiveValidators.append((validator, reason))
                validationFailed = true
                
                if validator.breakChain {
                    break
                }
            }
        }
        
        return !validationFailed
    }
}
