import UIKit

let billDay = 21

// Calulcate the nearest future billDate to EMI start date
func nearestFutureBillDate(forBillDay billDay: Int, for date: Date) -> Date {
    let calendar = Calendar(calendarIdentifier: .gregorian)!
    var dateComponents = calendar.components([.day, .month, .year], from: date)
    
    if billDay < dateComponents.day! {
        let futureDate = calendar.date(byAdding: .month, value: 1, to: date, options: [])!
        dateComponents = calendar.components([.day, .month, .year], from: futureDate)
    }
    
    dateComponents.day = billDay
    
    return calendar.date(from: dateComponents)!
}


let dateFormatter = DateFormatter()
dateFormatter.dateStyle = .shortStyle

nearestFutureBillDate(forBillDay: 21, for: Date())

let christmas = dateFormatter.date(from: "12/25/16")!
nearestFutureBillDate(forBillDay: 21, for: christmas)

let dec20 = dateFormatter.date(from: "12/20/16")!
nearestFutureBillDate(forBillDay: 20, for: dec20)




// Calculate the nearest past billDate to Today
func nearestPastBillDate(forBillDay billDay: Int, for date: Date) -> Date {
    let calendar = Calendar(calendarIdentifier: .gregorian)!
    var dateComponents = calendar.components([.day, .month, .year], from: date)
    
    if billDay > dateComponents.day! {
        let pastDate = calendar.date(byAdding: .month, value: -1, to: date, options: [])!
        dateComponents = calendar.components([.day, .month, .year], from: pastDate)
    }
    
    dateComponents.day = billDay
    
    return calendar.date(from: dateComponents)!
}

nearestPastBillDate(forBillDay: 21, for: Date())

nearestPastBillDate(forBillDay: 21, for: dateFormatter.date(from: "01/01/17")!)

nearestPastBillDate(forBillDay: 20, for: dateFormatter.date(from: "01/20/17")!)

nearestPastBillDate(forBillDay: 31, for: dateFormatter.date(from: "12/3/16")!)

// Calculate the difference between two in months
var startDate = dateFormatter.date(from: "03/02/16")!
var endDate = dateFormatter.date(from: "06/14/16")!
let calendar = Calendar(calendarIdentifier: .gregorian)!
let components = calendar.components([.month], from: startDate, to: endDate, options: .wrapComponents)
components.month

