import XCTest

class RequiredValidatorTests: XCTestCase {
    var validator: RequiredValidator!
    
    override func setUp() {
        super.setUp()
        validator = RequiredValidator()
    }
    
    func testEmptyStringFailsValidation() {
        let result = validator.validate("")
        
        XCTAssertEqual(result, ValidationResult.failure(.empty))
    }
    
    func testAnythingElseSucceeds() {
        let result = validator.validate("Vikram")
        
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationAlwaysSucceeds() {
        var result = validator.liveValidate(incompleteString: " ")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: " abc")
        XCTAssertEqual(result, ValidationResult.success)
    }
}
