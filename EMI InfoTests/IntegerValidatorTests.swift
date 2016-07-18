import XCTest

class IntegerValidatorTests: XCTestCase {
    var validator: IntegerValidator!
    
    override func setUp() {
        super.setUp()
        validator = IntegerValidator(minimum: 1, maximum: 31)
    }
    
    func testValidationFailsWithInvalidCharacters() {
        var result = validator.validate("abc")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
        
        result = validator.validate("12 3")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
    
    func testValidationFailsWhenDecimalNumberIsProvided() {
        let result = validator.validate("123.4")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
        
    }
    
    func testValidationFailsWhenIntegerProvidedIsLessThanMinimum() {
        let result = validator.validate("0")
        XCTAssertEqual(result, ValidationResult.failure(.short))
    }
    
    func testValidationFailsWhenIntegerProvidedIsMoreThanMaximum() {
        let result = validator.validate("32")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testValidationPassesWhenIntegerBetweenMaximumAndMinimumIsProvided() {
        let result = validator.validate("23")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationFailsWithInvalidCharacters() {
        var result = validator.liveValidate(incompleteString: "abc")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
        
        result = validator.liveValidate(incompleteString: "12 4")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
    
    func testLiveValidationFailsWhenDecimalNumberIsProvided() {
        let result = validator.liveValidate(incompleteString: "12.4")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
    
    func testLiveValidationFailsWhenIntegerIsGreaterThanMaximum() {
        let result = validator.liveValidate(incompleteString: "32")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testLiveValidationSucceedsWhenIntegerIsLessThanMinimum() {
        let result = validator.liveValidate(incompleteString: "0")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsWhenIntegerBetweenMinAndMaxIsGiven() {
        let result = validator.liveValidate(incompleteString: "23")
        XCTAssertEqual(result, ValidationResult.success)
    }
}
