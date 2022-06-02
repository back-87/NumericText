import NumericText
import XCTest

final class StringNumericTests: XCTestCase {
    let s = Locale.current.decimalSeparator ?? "."
    
    func testDoubleDecimal() {
        XCTAssertEqual("12\(s)3\(s)4".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "12\(s)34")
        XCTAssertEqual("12\(s)34".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "12\(s)34")
        XCTAssertEqual("\(s)1234\(s)".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "\(s)1234")
    }

    func testObscureNumericCharacters() throws {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        // DEVANAGARI 5
        let fiveString = "५"
        XCTAssertEqual(fiveString.numericValue(allowDecimalSeparator: false, allowNegativeNumbers: false), fiveString)
        let five = try XCTUnwrap(formatter.number(from: fiveString))
        XCTAssertEqual(five, 5)
    }

    func testAlphaNumeric() {
        XCTAssertEqual("12a\(s)3b4".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "12\(s)34")
        XCTAssertEqual("12abc34".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "1234")
        XCTAssertEqual("a\(s)1234\(s)".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "\(s)1234")
    }
    
    
    func testNegative() {
        XCTAssertEqual("52".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "52")
        XCTAssertEqual("-52".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: true), "-52")
        XCTAssertEqual("-52".numericValue(allowDecimalSeparator: true, allowNegativeNumbers: false), "52")
    }
}
