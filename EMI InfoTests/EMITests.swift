import XCTest
import CoreData


class EMITests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var creditCard: CreditCard!
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func setUp() {
        super.setUp()
        managedObjectContext = CoreDataStack.inMemoryManagedObjectContext()
        
        let creditCard = CreditCard(context: managedObjectContext)
        creditCard.billDay = 31
        creditCard.name = "Vikram"
        creditCard.issuingBank = "HDFC"
        creditCard.lastFourNumbers = 1234
        self.creditCard = creditCard
    }
    
    func testReturnsCompletedMonths() {
        let emi = EMI(context: managedObjectContext)
        
        emi.numberOfInstallments = 12
        emi.startDate = dateFormatter.date(from: "02/15/16")! as NSDate
        emi.creditCard = creditCard
        
        let currentDate = dateFormatter.date(from: "07/02/16")!
        XCTAssertEqual(emi.completedMonths(till: currentDate), 5)
        XCTAssertEqual(emi.monthsRemaining(since: currentDate), 7)
    }
    
    func testReturnsZeroIfTheFirstBillDateIsNotReached() {
        let emi = EMI(context: managedObjectContext)
        
        emi.numberOfInstallments = 12
        emi.startDate = dateFormatter.date(from: "06/28/16")! as NSDate
        emi.creditCard = creditCard
        
        let currentDate = dateFormatter.date(from: "06/29/16")!
        XCTAssertEqual(emi.completedMonths(till: currentDate), 0)
        XCTAssertEqual(emi.monthsRemaining(since: currentDate), 12)
    }
    
    func testReturnsTotalInstallmentsIfTheCompletedMonthsIsMoreThanThat() {
        let emi = EMI(context: managedObjectContext)
        
        emi.numberOfInstallments = 6
        emi.startDate = dateFormatter.date(from: "01/28/16")! as NSDate
        emi.creditCard = creditCard
        
        let currentDate = dateFormatter.date(from: "08/02/16")!
        XCTAssertEqual(emi.completedMonths(till: currentDate), 6)
        XCTAssertEqual(emi.monthsRemaining(since: currentDate), 0)
    }
    
    func testReturnsCompletedMonthsInMonthsNotHavingBillDay() {
        let emi = EMI(context: managedObjectContext)
        
        emi.numberOfInstallments = 6
        emi.startDate = dateFormatter.date(from: "02/28/16")! as NSDate
        emi.creditCard = creditCard
        
        var currentDate = dateFormatter.date(from: "02/29/16")!
        XCTAssertEqual(emi.completedMonths(till: currentDate), 0)
        XCTAssertEqual(emi.monthsRemaining(since: currentDate), 6)
        
        currentDate = dateFormatter.date(from: "03/01/16")!
        XCTAssertEqual(emi.completedMonths(till: currentDate), 0)
        XCTAssertEqual(emi.monthsRemaining(since: currentDate), 6)
        
        currentDate = dateFormatter.date(from: "03/02/16")!
        XCTAssertEqual(emi.completedMonths(till: currentDate), 1)
        XCTAssertEqual(emi.monthsRemaining(since: currentDate), 5)
    }
}
