import Foundation

extension EMI {
    func completedMonths(till date: Date) -> Int {
        guard let startDate = startDate as? Date else {
            fatalError("EMI start date is nil")
        }
        let calendar = Calendar(calendarIdentifier: .gregorian)!
        
        guard let creditCard = creditCard else {
            fatalError("No credit card associated with EMI")
        }

        let futBillDate = futureBillDate(for: startDate, withBillDay: Int(creditCard.billDay), in: calendar)

        guard futBillDate.timeIntervalSinceReferenceDate <= date.timeIntervalSinceReferenceDate else {
            return 0
        }
        
        let completedMonths = calendar.components([.month], from: futBillDate, to: date, options: []).month! + 1

        return completedMonths > Int(numberOfInstallments) ? Int(numberOfInstallments) : completedMonths
    }
    
    func monthsRemaining(since date: Date) -> Int {
        return Int(numberOfInstallments) - completedMonths(till: date)
    }
    
    private func futureBillDate(for date: Date, withBillDay billDay: Int, in calendar: Calendar) -> Date {
        var dateComponents = calendar.components([.day, .month, .year], from: date)
        
        if billDay < dateComponents.day! {
            let futureDate = calendar.date(byAdding: .month, value: 1, to: date, options: [])!
            dateComponents = calendar.components([.day, .month, .year], from: futureDate)
        }
        
        dateComponents.day = billDay
        
        return calendar.date(from: dateComponents)!
    }
}
