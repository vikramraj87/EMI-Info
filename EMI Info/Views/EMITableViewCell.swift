import UIKit

class EMITableViewCell: UITableViewCell, ConfigurableCell {
    
    // MARK: Outlets
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: Stored Properties
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    // MARK: ConfigurableCell
    typealias Object = EMI
    
    func configure(for object: Object) {
        nameLabel.text = object.name
        descriptionLabel.text = "\(object.completedMonths(till: Date())) of \(object.numberOfInstallments) months remaning"
        amountLabel.text = currencyFormatter.string(from: object.monthlyInstallment!)!
    }
}
