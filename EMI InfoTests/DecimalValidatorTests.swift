import XCTest

class DecimalValidatorTests: XCTestCase {
    var validator: DecimalValidator!
    
    override func setUp() {
        super.setUp()
        validator = DecimalValidator(minimum: 100.0, maximum: 1_00_000.0, maximumFractionalPlaces: 2)
    }
    
    func testValidationFailsWithEmptyString() {
        let result = validator.validate("")
        XCTAssertEqual(result, ValidationResult.failure(.empty))
    }
    
    func testValidationFailsWithInvalidCharacters() {
        var result = validator.validate("abc")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
        
        result = validator.validate("12 3")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
    
    func testValidatorFailsWhenNumberEndsInDecimalSeparator() {
        let result = validator.validate("10.")
        XCTAssertEqual(result, ValidationResult.failure(.endsInDecimalSeparator))
    }
    
  
    func testValidationFailsWhenTwoDecimalPlacesGiven() {
        var result = validator.validate("12.3.4")
        XCTAssertEqual(result, ValidationResult.failure(.moreThanOneDecimalSeparator))
        
        result = validator.validate(".12.3")
        XCTAssertEqual(result, ValidationResult.failure(.moreThanOneDecimalSeparator))
    }
    
    func testValidationFailsWhenDecimalIsLessThanMinimum() {
        let result = validator.validate("99.9")
        XCTAssertEqual(result, ValidationResult.failure(.short))
    }
    
    func testValidationFailsWhenIntegerIsLessThanMinimum() {
        let result = validator.validate("99")
        XCTAssertEqual(result, ValidationResult.failure(.short))
    }
    
    func testValidationFailsWhenDecimalIsMoreThanMaximum() {
        let result = validator.validate("100000.3")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }

    func testValidationFailsWhenIntegerIsMoreThanMaximum() {
        let result = validator.validate("100001")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testValidatorFailsWhenDecimalPlacesAreMore() {
        let result = validator.validate("9000.234")
        XCTAssertEqual(result, ValidationResult.failure(.longerFraction))
    }
    
    func testValidationPassesWhenDecimalWithinRangeIsGiven() {
        let result = validator.validate("90000.23")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testValidationPassesWhenIntegerWithinRangeIsGiven() {
        let result = validator.validate("90000")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationFailsWithInvalidCharacters() {
        var result = validator.liveValidate(incompleteString: "abc")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
        
        result = validator.liveValidate(incompleteString: "12 3")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
    
    func testLiveValidationFailsWhenTwoDecimalPlacesGiven() {
        var result = validator.liveValidate(incompleteString: "12.3.4")
        XCTAssertEqual(result, ValidationResult.failure(.moreThanOneDecimalSeparator))
        
        result = validator.liveValidate(incompleteString: ".2.")
        XCTAssertEqual(result, ValidationResult.failure(.moreThanOneDecimalSeparator))
    }
    
    func testLiveValidationFailsWhenDecimalIsGreaterThanMaximun() {
        let result = validator.liveValidate(incompleteString: "100000.1")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testLiveValidationFailsWhenDecimalIsLessThanMinimum() {
        let result = validator.liveValidate(incompleteString: "10.2")
        XCTAssertEqual(result, ValidationResult.failure(.short))
    }
    
    func testLiveValidationFailsWhenMoreDecimalPlacesAreGiven() {
        let result = validator.liveValidate(incompleteString: "1000.2324")
        XCTAssertEqual(result, ValidationResult.failure(.longerFraction))
    }
    
    func testLiveValidationFailsWhenIntegerIsGreaterThanMaximum() {
        let result = validator.liveValidate(incompleteString: "100001")
        XCTAssertEqual(result, ValidationResult.failure(.long))
    }
    
    func testLiveValidationSucceedsWhenDecimalSeparatorIsLastCharacter() {
        let result = validator.liveValidate(incompleteString: "120.")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsOnlyIntegerOfLowerValueIsGiven() {
        let result = validator.liveValidate(incompleteString: "10")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsWhenIntegerWithinRangeIsGiven() {
        let result = validator.liveValidate(incompleteString: "90000")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsWhenDecimalWithinRangeIsGiven() {
        let result = validator.liveValidate(incompleteString: "90000.50")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testLiveValidationSucceedsWhenIntegerLessThanMinimumIsGiven() {
        let result = validator.liveValidate(incompleteString: "100")
        XCTAssertEqual(result, ValidationResult.success)
    }
}
