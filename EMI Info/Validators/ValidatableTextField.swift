import UIKit
import ValidationKitiOS

protocol ValidatableTextFieldDelegate: UITextFieldDelegate {
    func validatorChain(for textField: UITextField) -> ValidatorChain?
    
    func textFieldsForValidation() -> [UITextField]?
    
    func failedValidator(for textField: UITextField) -> (([(Validator, FailedValidationReason)]?) -> Void)?
    
    func validate() -> Bool
}

extension ValidatableTextFieldDelegate {
    func validate() -> Bool {
        guard let textFields = textFieldsForValidation() else {
            return true
        }
        
        var failedValidation = false
        
        for textField in textFields {
            
            if !validateTextField(textField, failedValidationHandler: failedValidator(for: textField)) {
                failedValidation = true
            }
        }
        
        return !failedValidation
    }
    
    func validateTextField(_ textField: UITextField, failedValidationHandler: (([(Validator, FailedValidationReason)]?) -> Void)?) -> Bool {
        guard var validatorChain = validatorChain(for: textField) else {
            return true
        }
        
        let text = textField.text ?? ""
        let result = validatorChain.validate(text)
        
        if !result {
            failedValidationHandler?(validatorChain.failedValidators)
            return false
        }
        
        return true
    }
}
