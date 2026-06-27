//
//  TextInputTests.swift
//  Community Issue ReporterTests
//

import Testing
@testable import Community_Issue_Reporter

struct TextInputTests {

    @Test func testEmailValidatorValid() async throws {
        let validator = emailValidator[0]
        #expect(validator.fn("test@example.com") == true)
        #expect(validator.fn("user.name@domain.com.sv") == true)
        #expect(validator.fn("first.last@gmail.com") == true)
    }

    @Test func testEmailValidatorInvalid() async throws {
        let validator = emailValidator[0]
        #expect(validator.fn("invalid-email") == false)
        #expect(validator.fn("test@") == false)
        #expect(validator.fn("@domain.com") == false)
        #expect(validator.fn("test@domain") == false)
        #expect(validator.fn("test @domain.com") == false)
    }

    @Test func testCustomValidator() async throws {
        let minLengthValidator = Validator(name: "Min Length", message: "Too short", fn: { $0.count >= 5 })
        
        #expect(minLengthValidator.fn("12345") == true)
        #expect(minLengthValidator.fn("1234") == false)
    }
    
    @Test func testEmptyValidator() async throws {
        let nonEmptyValidator = Validator(name: "Non Empty", message: "Required", fn: { !$0.isEmpty })
        
        #expect(nonEmptyValidator.fn("text") == true)
        #expect(nonEmptyValidator.fn("") == false)
    }
}
