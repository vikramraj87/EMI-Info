import XCTest

class StringLengthValidatorTests: XCTestCase {
    var validator: StringLengthValidator!
    
    override func setUp() {
        super.setUp()
        validator = StringLengthValidator(minimumLength: 4, maximumLength: 8)
    }
    
    func testValidationFailsForSmallStrings() {
        var result = validator.validate("")
        XCTAssertEqual(result, ValidationResult.failure(.short))
        
        result = validator.validate("ab")
        XCTAssertEqual(result, ValidationResult.failure(.short))
        
        result = validator.validate("abc")
        XCTAssertEqual(result, ValidationResult.failure(.short))
    }
    
    func testValidationFailsForLongStrings() {
        let result = validator.validate("abcdefghij")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testValidationSucceedsForCorrectStrings() {
        var result = validator.validate("abcd")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("abcde")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("abcdef")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("abcdefg")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("abcdefgh")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsIfTheStringIsShort() {
        var result = validator.liveValidate(incompleteString: "")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "ab")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "abc")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsForCorrectLength() {
        var result = validator.liveValidate(incompleteString: "abcd")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "abcde")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "abcdef")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "abcdefg")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "abcdefgh")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationFailsForLongString() {
        let result = validator.liveValidate(incompleteString: "abcdefghij")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
}
