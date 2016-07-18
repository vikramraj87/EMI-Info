import XCTest

struct MockSuccessfulValidator: Validator {
    var breakChain: Bool = false
    
    func validate(_ string: String) -> ValidationResult {
        return .success
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        return .success
    }
}

struct MockFailureValidatorWithBreakChain: Validator {
    var breakChain: Bool = true
    
    func validate(_ string: String) -> ValidationResult {
        return .failure(.empty)
    }

    func liveValidate(incompleteString string: String) -> ValidationResult {
        return .failure(.empty)
    }
}

struct MockFailureValidatorWithoutBreakChain: Validator {
    var breakChain: Bool = false
    
    func validate(_ string: String) -> ValidationResult {
        return .failure(.short)
    }
    
    func liveValidate(incompleteString string: String) -> ValidationResult {
        return .failure(.short)
    }
}

class ValidatorChainTests: XCTestCase {
    override func setUp() {
        super.setUp()
        
    }
    
    func testFailedValidationWithoutBreakChainReturnsAllFailedValidations() {
        var chain = ValidatorChain(validators: [
            MockFailureValidatorWithoutBreakChain(),
            MockFailureValidatorWithoutBreakChain(),
            MockSuccessfulValidator(),
            MockFailureValidatorWithoutBreakChain()
        ])
        
        var result = chain.validate("")
        XCTAssertFalse(result)
        
        result = chain.liveValidate(incompleteString: "")
        XCTAssertFalse(result)
        
        let failedValidators = chain.failedValidators
        let failedLiveValidators = chain.failedLiveValidators
        
        XCTAssertEqual(3, failedValidators.count)
        XCTAssertEqual(3, failedLiveValidators.count)
    }
    
    func testFailedValidationWithBreakChainReturnsAllFailedValidationsTillThatValidator() {
        var chain = ValidatorChain(validators: [
            MockFailureValidatorWithoutBreakChain(),
            MockFailureValidatorWithBreakChain(),
            MockSuccessfulValidator(),
            MockFailureValidatorWithoutBreakChain()
        ])
        
        var result = chain.validate("")
        XCTAssertFalse(result)
        
        result = chain.liveValidate(incompleteString: "")
        XCTAssertFalse(result)
        
        let failedValidators = chain.failedValidators
        let failedLiveValidators = chain.failedLiveValidators
        
        XCTAssertEqual(2, failedValidators.count)
        XCTAssertEqual(2, failedLiveValidators.count)
    }
    
    func testSuccessfulValidationReturnsTrue() {
        var chain = ValidatorChain(validators: [
            MockSuccessfulValidator(),
            MockSuccessfulValidator(),
            MockSuccessfulValidator(),
            MockSuccessfulValidator()
        ])
        
        var result = chain.validate("")
        XCTAssertTrue(result)
        
        result = chain.liveValidate(incompleteString: "")
        XCTAssertTrue(result)
        
        let failedValidators = chain.failedValidators
        let failedLiveValidators = chain.failedLiveValidators
        
        XCTAssertEqual(0, failedValidators.count)
        XCTAssertEqual(0, failedLiveValidators.count)
    }
}
