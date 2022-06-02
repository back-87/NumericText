import SwiftUI
import os

@available(iOS 14.0, *)
let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: NumericTextModifier.self)
)


/// A modifier that observes any changes to a string, and updates that string to remove any non-numeric characters.
/// It also will convert that string to a `NSNumber` for easy use.
public struct NumericTextModifier: ViewModifier {
    /// Should the user be allowed to enter a decimal number, or an integer
    public let isDecimalAllowed: Bool
    /// Should the user be allowed to enter a negative number
    public let isNegativeAllowed: Bool
    /// Number formatter used to format numer in view
    public var numberFormatter: NumberFormatter
    
    /// The string that the text field is bound to
    @Binding public var text: String
    /// A number that will be updated when the `text` is updated.
    @Binding public var number: NSNumber?
        
    /// A modifier that observes any changes to a string, and updates that string to remove any non-numeric characters.
    /// It also will convert that string to a `NSNumber` for easy use.
    ///
    /// - Parameters:
    ///   - text: The string that this should observe and filter
    ///   - number: A number that should be updated whenever the `text` is updated
    ///   - isDecimalAllowed: Should the user be allowed to enter a decimal number, or an integer
    ///   - numberFormatter: Custom number formatter used for formatting number in view
    public init(text: Binding<String>, number: Binding<NSNumber?>, isDecimalAllowed: Bool, isNegativeAllowed: Bool, numberFormatter: NumberFormatter? = nil) {
        _text = text
        _number = number
        self.isDecimalAllowed = isDecimalAllowed
        self.isNegativeAllowed = isNegativeAllowed
        self.numberFormatter = numberFormatter ?? decimalFormatterMaintainingDecimalDigits(number.wrappedValue ?? NSNumber(value: 0.0))
    }

    public func body(content: Content) -> some View {
        return content
            .onChangeShimmed(of: text) { newValue in
                let numeric = newValue.numericValue(allowDecimalSeparator: isDecimalAllowed, allowNegativeNumbers: isNegativeAllowed)
                if newValue != numeric {
                    text = numeric
                }
               
                if isDecimalAllowed  {
                    number = decimalFormatterMaintainingDecimalDigits(NSNumber(value: Double(text) ?? Double(0.0))).number(from: numeric)
                } else {
                    number = (NSNumber(value: Int(text) ?? Int(0)))
                }
            }
            
            .onChangeShimmed(of: number, perform: { newValue in
                
                if let number = newValue {
                    if isDecimalAllowed {
                        text = decimalFormatterMaintainingDecimalDigits(number).string(from: number) ?? ""
                    } else {
                        text = number.stringValue
                    }
                }
                else {
                    text = ""
                }
            })
             
    }
}

public extension View {
    /// A modifier that observes any changes to a string, and updates that string to remove any non-numeric characters.
    /// It also will convert that string to a `NSNumber` for easy use.
    func numericText(text: Binding<String>, number: Binding<NSNumber?>, isDecimalAllowed: Bool, isNegativeAllowed: Bool, numberFormatter: NumberFormatter?) -> some View {
        modifier(NumericTextModifier(text: text, number: number, isDecimalAllowed: isDecimalAllowed, isNegativeAllowed: isNegativeAllowed, numberFormatter: numberFormatter))
    }
}
