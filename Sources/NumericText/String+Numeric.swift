import Foundation

public extension String {
    /// Get the numeric only value from the string
    /// - Parameter allowDecimalSeparator: If `true` then a single decimal separator will be allowed in the string.
    /// - Parameter allowNegativeNumbers: If `true` then a single -  indicator will be allowed in the string.
    /// - Returns: Only numeric characters and optionally a single decimal and negative character. If non-numeric values were interspersed `1a2b` then the result will be `12`.
    ///            The numeric characters returned may be outside the normal 0-9 ASCII that you would expect. So you should avoid trying any `Int(someString)` with the results.
    ///            Stick to using `NumberFormatter` like Apple intended.
    func numericValue(allowDecimalSeparator: Bool, allowNegativeNumbers: Bool) -> String {
        var hasFoundDecimal = false
        var hasFoundNegativeIndicator = false
        return self.filter {
            if $0.isWholeNumber {
                return true
            }
            else if allowDecimalSeparator && String($0) == (Locale.current.decimalSeparator ?? ".") {
                defer { hasFoundDecimal = true }
                return !hasFoundDecimal
            }
            else if allowNegativeNumbers && String($0) == "-" {
                defer { hasFoundNegativeIndicator = true }
                return !hasFoundNegativeIndicator
            }
            return false
        }
    }
}
