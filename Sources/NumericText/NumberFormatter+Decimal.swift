import Foundation

var decimalNumberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()


var decimalFormatterMaintainingDecimalDigits  = { (number : NSNumber) -> NumberFormatter in

    let formatter = NumberFormatter()

    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = (number.stringValue.components(separatedBy: Locale.current.decimalSeparator ?? ".").last)!.count
    
    formatter.numberStyle = .none
    formatter.groupingSize = 0
    formatter.roundingMode = .floor
    formatter.minimumIntegerDigits = 1
    
    return formatter
}
