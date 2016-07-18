//
//  CreditCardTests.swift
//  EMI Info
//
//  Created by Vikram Raj Gopinathan on 02/07/16.
//  Copyright © 2016 Kivi. All rights reserved.
//

import XCTest
import CoreData

class CreditCardTests: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    
    var creditCard: CreditCard!
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    override func setUp() {
        super.setUp()
        
        managedObjectContext = CoreDataStack.inMemoryManagedObjectContext()
        
        let creditCard = CreditCard(context: managedObjectContext)
        creditCard.billDay = 21
        creditCard.name = "Vikram"
        creditCard.issuingBank = "HDFC"
        creditCard.lastFourNumbers = 4321
        
        let emis = creditCard.mutableSetValue(forKeyPath: "emis")
        
        emis.add(emiWith(name: "iMac", startDateString: "06/26/16", amount: 17_000.00, numberOfInstallments: 9))
        emis.add(emiWith(name: "4k Monitor", startDateString: "05/04/15", amount: 4000.00, numberOfInstallments: 12))
        emis.add(emiWith(name: "Phone", startDateString: "04/24/16", amount: 4500.00, numberOfInstallments: 12))
        emis.add(emiWith(name: "Table", startDateString: "04/01/16", amount: 3000.00, numberOfInstallments: 3))
        
        self.creditCard = creditCard
    }
    
    func testCalculatingTotalActiveInstallments() {
        let currentDate = dateFormatter.date(from: "07/02/16")!
        XCTAssertEqual(creditCard.totalActiveMonthlyInstallments(at: currentDate), 21_500.00)
    }
    
    private func emiWith(name: String, startDateString: String, amount: Float, numberOfInstallments: Int) -> EMI {
        let emi = EMI(context: managedObjectContext)
        
        emi.name = name
        emi.startDate = dateFormatter.date(from: startDateString)! as NSDate
        emi.monthlyInstallment = NSDecimalNumber(value: amount)
        emi.numberOfInstallments = Int16(numberOfInstallments)
        
        return emi
    }
}
