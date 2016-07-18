import XCTest

class DigitsValidatorTests: XCTestCase {
    var validator: DigitsValidator!
    
    override func setUp() {
        super.setUp()
        validator = DigitsValidator(minimumLength: 4, maximumLength: 8)
    }
    
    func testValidationFailsWhenTheNumberOfDigitsIsLess() {
        let result = validator.validate("123")
        XCTAssertEqual(result, ValidationResult.failure(.short))
    }
    
    func testValidationFailsWhenTheNumberOfDigitsIsMore() {
        let result = validator.validate("123456789")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testValidationFailsWhenCharactersOtherThanDigitsProvided() {
        var result = validator.validate("12a4")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
        
        result = validator.validate("12.4")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
    
    func testValidationSucceedsIfOnlyDigitsProvided() {
        var result = validator.validate("1234")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("12345")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("123456")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("1234567")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("12345678")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsWhenLessDigitsAreProvided() {
        var result = validator.liveValidate(incompleteString: "1")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "12")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsWhenDigitsAreCorrect() {
        var result = validator.liveValidate(incompleteString: "1234")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "12345")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "123456")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "1234567")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "12345678")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationFailsWhenDigitsAreMore() {
        let result = validator.liveValidate(incompleteString: "123456789")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testLiveValidationFailsWhenCharactersOtherThanDigitsAreProvided() {
        let result = validator.liveValidate(incompleteString: "1a34")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
}
