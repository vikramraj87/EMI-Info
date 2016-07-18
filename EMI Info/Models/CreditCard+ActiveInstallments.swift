import Foundation
import CoreData

extension CreditCard {
    func totalActiveMonthlyInstallments(at date: Date) -> Float {
        let emis = self.emis as! Set<EMI>
        
        var total: Float = 0.0
        
        for emi in emis {
            if emi.monthsRemaining(since: date) > 0 {
                total += emi.monthlyInstallment!.floatValue
            }
        }
        
        return total
    }
    
    func futureBillDate(for date: Date) -> Date {
        let calendar = Calendar(calendarIdentifier: .gregorian)!
        var dateComponents = calendar.components([.day, .month, .year], from: date)
        
        let billDay = Int(self.billDay)
        
        if billDay < dateComponents.day! {
            let futureDate = calendar.date(byAdding: .month, value: 1, to: date, options: [])!
            dateComponents = calendar.components([.day, .month, .year], from: futureDate)
        }
        
        dateComponents.day = billDay
        
        return calendar.date(from: dateComponents)!
    }
}
