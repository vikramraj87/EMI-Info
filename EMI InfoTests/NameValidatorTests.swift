import XCTest

class NameValidatorTests: XCTestCase {
    var validator: NameValidator!
    
    override func setUp() {
        super.setUp()
        validator = NameValidator()
    }
    
    func testEmptyStringPassesValidation() {
        let result = validator.validate("")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testStringWithInvalidCharactersFailsValidation() {
        let result = validator.validate("%$#^")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }
    
    func testStringWithValidCharactersPassesValidation() {
        var result = validator.validate("name-something")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("-something")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("something")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("something_")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.validate("name of something")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testEmptyStringPassesLiveValidation() {
        let result = validator.liveValidate(incompleteString: "")
        XCTAssertEqual(result, ValidationResult.success)
    }
    
    func testStringWithInvalidCharactersFailsLiveValidation() {
        let result = validator.liveValidate(incompleteString: "$%")
        XCTAssertEqual(result, ValidationResult.failure(.invalidCharacters))
    }

    func testStringWithValidCharactersPassesLiveValidation() {
        var result = validator.liveValidate(incompleteString: "name")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "name of")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "name of-")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "name of-something")
        XCTAssertEqual(result, ValidationResult.success)
        
        result = validator.liveValidate(incompleteString: "name of_something")
        XCTAssertEqual(result, ValidationResult.success)
    }
}

