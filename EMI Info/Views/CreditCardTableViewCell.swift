//
//  CreditCardTableViewCell.swift
//  EMI Info
//
//  Created by Vikram Raj Gopinathan on 23/06/16.
//  Copyright © 2016 Kivi. All rights reserved.
//

import UIKit

class CreditCardTableViewCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var lastFourNumbersLabel: UILabel!
    @IBOutlet weak var totalEMILabel: UILabel!
    
    // Formatter for last four numbers of credit card.
    // Enables padding of number with zero. Eg: 1234, 0011
    static let lastFourNumberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.paddingCharacter = "0"
        formatter.formatWidth = 4
        return formatter
    }()
    
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialize
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK:-
    // MARK: ConfigurableCell
    typealias Object = CreditCard
    
    func configure(for object: Object) {
        identifierLabel.text = "\(object.name!) (\(object.issuingBank!))"
        lastFourNumbersLabel.text = {
            let lastFourNumbers = CreditCardTableViewCell.lastFourNumberFormatter.string(from: NSNumber(value: object.lastFourNumbers))!
            return "xxxx xxxx xxxx \(lastFourNumbers)"
        }()
        totalEMILabel.text = CreditCardTableViewCell.currencyFormatter.string(from: NSNumber(value: object.totalActiveMonthlyInstallments(at: Date())))
    }
}
