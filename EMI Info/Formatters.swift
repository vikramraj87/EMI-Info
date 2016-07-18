import Foundation


struct Formatters {
    static let creditCardLastFourNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.paddingCharacter = "0"
        formatter.formatWidth = 4
        return formatter
    }()
    
    static let creditCardBillDayFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.paddingCharacter = "0"
        formatter.formatWidth = 2
        return formatter
    }()
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    static let monthsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        return formatter
    }()
}
